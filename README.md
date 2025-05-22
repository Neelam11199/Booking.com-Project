📘 Booking Analysis Project
Overview
This project involves cleaning, transforming, and analyzing hotel booking data using SQL. The main goals are to handle data quality issues, create a deduplicated view of the dataset, and extract key business insights from the data.

Files Included
1. booking_Dataset.csv
Description: Raw dataset containing hotel booking details including customer info, booking preferences, and transaction details.

Key Columns:

booking_id, booking_date, hotel, country

market_segment, price, is_canceled

adults, children, meal, reservation_status

email, name, required_car_parking_spaces, deposit_type

2. booking queries.sql
Description: SQL script that performs data cleaning and generates analytical insights from the dataset.

SQL Script Sections
1. 🔧 Data Cleaning
Null Handling: Replaces NULL values with default values or aggregated data.

Duplicate Removal: Uses a window function (ROW_NUMBER()) to retain only the first occurrence of duplicate booking_ids.

View Created: booking_view — a cleaned version of the bookings table.

2. 📊 Business Insights & Analytics
Key questions addressed:

Cancellation Rate: Calculates overall cancellation percentage.

Top Booking Countries: Identifies countries contributing the most revenue.

Market Segment Analysis: Finds top-performing segments by revenue.

Deposit vs Cancellation: Correlates deposit type with cancellation likelihood.

Meal Preferences: Shows most popular meal types.

Seasonal Pricing Trends: Compares average prices by month and hotel.

Car Parking Demand: Analyzes parking space demand by location.

Reservation Status: Distribution and trend over time.

Guest Composition: Booking distribution by adults, children, and weekend nights.

Email Domains: Most commonly used domains for bookings.

Frequent Bookers: Names with the highest number of bookings.

Quarterly Trends: Booking patterns across seasons.
