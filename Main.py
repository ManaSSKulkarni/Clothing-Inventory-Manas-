from flask import Flask, render_template, request, redirect, url_for, session
import json
import mysql.connector
from decimal import Decimal
from datetime import date


with open('Config.json', 'r') as c:
    param = json.load(c)["parameters"]


local_server=True
app = Flask(__name__)
app.secret_key = 'SECRET_KEY'


# Connect to MySQL using mysql.connector
if local_server:
    db = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="clothing_inventory"
    )
cursor = db.cursor()

@app.route("/")
@app.route("/home" , methods=['GET','POST'])
def home():
    if request.method == 'POST':
        return redirect('/placeorder')

    return render_template('Home.html')


@app.route("/about")
def about():
    name="ABOUT US"
    cursor.execute("SELECT * FROM Inventory")
    inventory_data = cursor.fetchall()
    cursor.execute("SELECT * FROM Employees")
    employees = cursor.fetchall()
    return render_template('About.html', name=name, inventory_data=inventory_data,employees=employees)


@app.route("/contact")
def contact():
    name="CONTACT"
    return render_template('Contact.html', name=name)



@app.route("/adminlogin", methods=['GET','POST'])
def admin_login():
    name = "ADMIN LOGIN"
    if ('user' in session) and (session['user'] == param['admin_username']):
        cursor.execute("SELECT * FROM Employees")
        employees = cursor.fetchall()
        cursor.execute("SELECT * FROM Garments")
        garments = cursor.fetchall()
        return redirect('/adminpage')
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        if (username == param['admin_username']) and (password == param['admin_password']):
            session['user'] = username
            return redirect('/adminpage')
        else:
            return redirect('/adminlogin')
    else:
        return render_template('AdminLogin.html', name=name)


@app.route("/adminpage", methods=['GET', 'POST'])
def adminpage():
    if 'user' in session and session['user'] == param['admin_username']:
        if 'employees' in request.form:
            return redirect('/displayemployees')
        if 'garments' in request.form:
            return redirect('/adminselectcategory')
        if 'orders' in request.form:
            return redirect('/displayorders')
    else:
        return redirect('/adminlogin')

    return render_template('FreshAdminPage.html')


@app.route("/displayemployees", methods=['GET', 'POST'])
def displayemployees():
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Employees ORDER BY date_of_joining")
    employees = cursor.fetchall()

    return render_template('DisplayEmployees.html', param=param, employees=employees)


@app.route("/adminselectcategory", methods=['GET', 'POST'])
def adminselectcategory():
    if request.method == 'POST':
        category = request.form['category']
        return redirect(url_for('display_garments', category=category))

    return render_template('AdminSelectCategory.html')


@app.route("/displaygarments", methods=['GET', 'POST'])
def display_garments():
    category = request.args.get('category')
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Garments WHERE garment_category = %s GROUP BY g_size, garment_type", (category,))
    garments = cursor.fetchall()

    return render_template('DisplayGarments.html', garments=garments)


@app.route("/displayorders", methods=['GET', 'POST'])
def display_orders():
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Orders ORDER BY order_date")
    orders = cursor.fetchall()

    return render_template('DisplayOrders.html', orders=orders)


@app.route("/admin", methods=['GET', 'POST'])
def adm():
    if 'user' in session and session['user'] == param['admin_username']:
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM Employees")
        employees = cursor.fetchall()
        cursor.execute("SELECT * FROM Garments")
        garments = cursor.fetchall()
        cursor.close()
        return render_template('AdminPage.html',param=param,employees=employees,garments=garments)
    else:
        return redirect('/adminlogin')


@app.route("/employee_edit/<string:emp_id>", methods=['GET', 'POST'])
def employee_edit(emp_id):
    if 'user' in session and session['user'] == param['admin_username']:
        if request.method == 'POST':
            name = request.form.get('name')
            contact = request.form.get('phone')
            date = request.form.get('date')
            salary = request.form.get('salary')
            cursor = db.cursor()

            if emp_id == '0':
                cursor.execute("SELECT MAX(emp_id) FROM Employees")  # Get the last emp_id
                max_id = cursor.fetchone()[0]  # Fetch the last emp_id
                new_id = max_id + 1   # Increment the emp_id
                cursor.execute("INSERT INTO Employees (emp_id, emp_name, emp_phone, date_of_joining, emp_salary) VALUES (%s, %s, %s, %s, %s)",(new_id, name, contact, date, salary))
                db.commit()
                return redirect('/displayemployees')
            else:
                cursor.execute("UPDATE Employees SET emp_name = %s, emp_phone = %s, date_of_joining = %s, emp_salary = %s WHERE emp_id = %s",(name, contact, date, salary, emp_id))
                db.commit()

            cursor.close()
            return redirect('/displayemployees')

        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM Employees WHERE emp_id = %s", (emp_id,))
        employee = cursor.fetchone()
        cursor.close()

        return render_template('EmployeeEdit.html', param=param, employee=employee)
    else:
        return redirect('/adminlogin')


@app.route("/employee_delete/<string:emp_id>", methods=['GET', 'POST'])
def empdelete(emp_id):
    if 'user' in session and session['user'] == param['admin_username']:
        cursor = db.cursor(dictionary=True)
        # Execute SQL query to delete the employee
        cursor.execute("DELETE FROM Employees WHERE emp_id = %s", (emp_id,))
        db.commit()
        cursor.close()
    return redirect('/displayemployees')


@app.route("/garment_edit/<string:g_id>", methods=['GET', 'POST'])
def garment_edit(g_id):
    if 'user' in session and session['user'] == param['admin_username']:
        if request.method == 'POST':
            identity = request.form.get('identity')
            type = request.form.get('type')
            category = request.form.get('category')
            quantity = int(request.form.get('quantity'))
            size = int(request.form.get('size'))
            price = Decimal(request.form.get('price'))
            cursor = db.cursor()

            if g_id == 'new':
                cursor.execute("INSERT INTO Garments (g_id,garment_type,garment_category,available_quantity,g_size,g_price) VALUES (%s,%s, %s, %s, %s, %s)",(identity,type,category,quantity,size,price))
                db.commit()
                return redirect('/adminselectcategory')
            else:
                cursor.execute("UPDATE Garments SET g_id = %s, garment_type = %s, garment_category = %s,  available_quantity= %s, g_size= %s, g_price= %s  WHERE g_id = %s",(identity,type,category,quantity,size,price,identity))
                db.commit()
                return redirect('/adminselectcategory')

            return redirect('/adminselectcategory')

        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM Garments WHERE g_id = %s", (g_id,))
        garment = cursor.fetchone()
        cursor.close()

        return render_template('GarmentEdit.html', param=param, garment=garment)
    else:
        return redirect('/adminlogin')


@app.route("/garment_delete/<string:g_id>", methods=['GET', 'POST'])
def garmentdelete(g_id):
    if 'user' in session and session['user'] == param['admin_username']:
        cursor = db.cursor(dictionary=True)
        # Execute SQL query to delete the garment
        cursor.execute("DELETE FROM Garments WHERE g_id = %s", (g_id,))
        db.commit()
        cursor.close()
    return redirect('/adminpage')


@app.route("/order_delete/<string:order_number>", methods=['GET', 'POST'])
def orderdelete(order_number):
    if 'user' in session and session['user'] == param['admin_username']:
        cursor = db.cursor(dictionary=True)
        cursor.execute("DELETE FROM Orders WHERE order_number = %s", (order_number,))
        db.commit()
        cursor.close()
    return redirect('/displayorders')


@app.route("/logout")
def logout():
    session.pop('user')
    return redirect('/home')

@app.route("/placeorder", methods=['GET', 'POST'])
def sign_in():
    Name = "SIGN IN"
    if request.method == "POST":
        name = request.form['name']
        username = request.form['username']
        email = request.form['email']
        phone = request.form['phone']
        mode = request.form['mode']
        session['name'] = name
        session['username'] = username

        cursor.execute("SELECT * FROM Customers WHERE cust_name = %s OR username = %s",(name, username))
        existing_customer = cursor.fetchone()
        if existing_customer:
            # Redirect to login route
            session['name'] = name
            session['username'] = username
            return redirect(url_for('login'))

        # Insert new customer
        cursor.execute("""INSERT INTO Customers (cust_name, username, cust_email, cust_contact, payment_mode) VALUES (%s, %s, %s, %s, %s)""", (name, username, email, phone, mode))
        db.commit()
        return redirect(url_for('select_category'))

    return render_template('SignIn.html', Name=Name)

@app.route("/login", methods=['GET', 'POST'])
def login():
    if request.method == "POST":
        name = request.form['name']
        username = request.form['username']

        cursor.execute("SELECT * FROM Customers WHERE cust_name = %s AND username = %s", (name, username))
        existing_customer = cursor.fetchone()
        if existing_customer:
            session['name'] = name
            session['username'] = username
            return redirect(url_for('select_category'))
        else:
            return render_template('login.html', error="Invalid name or username.")

    return render_template('login.html')


# Route for category selection
@app.route("/selectcategory", methods=['GET', 'POST'])
def select_category():
    if request.method == 'POST':
        category = request.form['category']
        session['category'] = category
        print("At select_category(), category =", category)
        return redirect(url_for('garment_order1', category=category))
    return render_template('SelectCategory.html')


@app.route("/garmentorder1", methods=['GET', 'POST'])
def garment_order1():
    name = session.get('name')
    username = session.get('username')
    category = session.get('category')
    cart = session.get('cart', {})  # Retrieve the cart items from the session OR initialize an empty dictionary
    print("At garment_order1(), category =",category)

    if request.method == 'POST':
        selected_garment_type = request.form.get('garment_type')
        session['selected_garment_type'] = selected_garment_type
        return redirect(url_for('garment_order2'))

    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Garments WHERE garment_category = %s GROUP BY g_size, garment_type", (category,))
    garments = cursor.fetchall()
    cursor.execute("SELECT order_date, bill_amt FROM Orders WHERE cust_id = (SELECT cust_id FROM Customers WHERE username = %s)", (username,))
    order_history = cursor.fetchall()

    return render_template('Garment_order1.html', garments=garments, name=name, username=username, cart=cart, order_history=order_history)


@app.route("/garmentorder2", methods=['GET', 'POST'])
def garment_order2():
    name = session.get('name')
    username = session.get('username')
    cart = session.get('cart', {})
    selected_garment_type = session.get('selected_garment_type')
    category = session.get('category')

    if request.method == 'POST':
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM Garments WHERE garment_type = %s AND garment_category = %s GROUP BY g_size, garment_type",(selected_garment_type, category,))
        garments = cursor.fetchall()

        for garment in garments:
            quantity = request.form.get('entered_quantity_' + garment['g_id'])
            if quantity and int(quantity) > 0:
                #add the garment to the cart
                g_id = garment['g_id']
                garment_type = garment['garment_type']
                garment_category = garment['garment_category']
                g_size = garment['g_size']
                garment_price = garment['g_price']

                # Add garment to the cart
                cart[g_id] = {
                    'g_id': g_id,
                    'garment_type': garment_type,
                    'garment_category': garment_category,
                    'g_size': g_size,
                    'quantity': int(quantity),
                    'garment_price' : garment_price
                }


        session['cart'] = cart
        return redirect(url_for('verify_order'))

    #retrieve garments for rendering the template
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Garments WHERE garment_type = %s AND garment_category = %s GROUP BY g_size, garment_type",(selected_garment_type, category,))
    garments = cursor.fetchall()
    cursor.execute("SELECT order_date, bill_amt FROM Orders WHERE cust_id = (SELECT cust_id FROM Customers WHERE username = %s)", (username,))
    order_history = cursor.fetchall()

    return render_template('Garment_order2.html', garments=garments, name=name, username=username, cart=cart, order_history=order_history)



@app.route("/verify", methods=['GET', 'POST'])
def verify_order():
    name = session.get('name')
    username = session.get('username')
    cart = session.get('cart')  # Retrieve the cart items from the session

    if request.method == 'POST':
        if 'add_more' in request.form:
            # Redirect to select_category with the current cart items
            return redirect(url_for('select_category', cart=cart))

        elif 'place_order' in request.form:
            return redirect(url_for('printing_bill', name=name, username=username, **cart))

    return render_template('Verify.html', cart=cart)


@app.route("/printing_bill", methods=['GET','POST'])
def printing_bill():
    name = session.get('name')
    username = session.get('username')
    cart = session.get('cart')
    print("Cart=",cart)
    total_amount = Decimal(0)
    payment_mode = None
    cust_email = None
    cust_contact = None
    cursor = db.cursor(dictionary=True)

    for garment_id, garment_data in cart.items():
        g_id = garment_data['g_id']
        quantity = garment_data['quantity']

        # Retrieve garment details from the database
        cursor.execute("SELECT g_price, available_quantity FROM Garments WHERE g_id = %s", (g_id,))
        garment_info = cursor.fetchone()

        if garment_info:
            g_price = Decimal(garment_info['g_price'])
            available_quantity = int(garment_info['available_quantity'])

            # Calculate the total amount for the current garment
            total_amount += g_price * quantity

            # Update the available quantity in the database
            new_quantity = available_quantity - quantity
            cursor.execute("UPDATE Garments SET available_quantity = %s WHERE g_id = %s", (new_quantity, g_id))
            db.commit()

    # Retrieve cust_id using username
    cursor.execute("SELECT cust_id FROM Customers WHERE username = %s", (username,))
    cust_info = cursor.fetchone()
    if cust_info:
        cust_id = cust_info['cust_id']
        cursor.execute("SELECT payment_mode, cust_email, cust_contact FROM Customers WHERE cust_id = %s", (cust_id,))
        customer_info = cursor.fetchone()
        if customer_info:
            payment_mode = customer_info['payment_mode']
            cust_email = customer_info['cust_email']
            cust_contact = customer_info['cust_contact']
            if cust_id:
                today = date.today()
                order_date = today.strftime("%Y-%m-%d")
                cursor.execute("INSERT INTO Orders (order_date, bill_amt, cust_id, ordered_by) VALUES (%s, %s, %s, %s)", (order_date, total_amount, cust_id, name))
                db.commit()

    if request.method == 'POST':
        if 'order_again' in request.form:
            session.pop('cart')
            return redirect(url_for('login'))
        if 'back_to_home' in request.form:
            session.pop('name')
            session.pop('username')
            session.pop('cart')
            return redirect('/home')

    return render_template('Printing_Bill.html', name=name, username=username, cart=cart, total_amount=total_amount, payment_mode=payment_mode, cust_email=cust_email, cust_contact=cust_contact)

if __name__ == "__main__":
    app.run(debug=True)
