"""Скрипт для заполнения данными таблиц в БД Postgres."""
import psycopg2
import csv
import os

EMPLOYEES = os.path.join('north_data', 'employees_data.csv')
CUSTOMERS = os.path.join('north_data', 'customers_data.csv')
ORDERS = os.path.join('north_data', 'orders_data.csv')


def get_data_from_cvs(filename):
    """ Достаёт данные из файла """
    with open(filename, encoding='utf-8') as file:
        return list(csv.DictReader(file))


connection = psycopg2.connect(database='north', user='postgres',
                              password=5682)

with connection as conn:
    with conn.cursor() as cur:
        employ_data = get_data_from_cvs(EMPLOYEES)
        for row in employ_data:
            cur.execute("INSERT INTO employees (employee_id, "
                        "first_name, last_name, title, birth_date, "
                        "notes) VALUES (%s, %s, %s, %s, %s, %s)",
                        (row['employee_id'], row['first_name'],
                         row['last_name'], row['title'],
                         row['birth_date'], row['notes']))
        custom_data = get_data_from_cvs(CUSTOMERS)
        for row in custom_data:
            cur.execute("INSERT INTO customers (customer_id, "
                        "company_name, contact_name) VALUES "
                        "(%s, %s, %s)", (row['customer_id'],
                                         row['company_name'],
                                         row['contact_name']))
        order_data = get_data_from_cvs(ORDERS)
        for row in order_data:
            cur.execute("INSERT INTO orders (order_id, customer_id, "
                        "employee_id, order_date, ship_city) VALUES "
                        "(%s, %s, %s, %s, %s)",
                        (row['order_id'], row['customer_id'],
                         row['employee_id'], row['order_date'],
                         row['ship_city']))

