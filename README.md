# Flutter Amazon Clone

A comprehensive Full Stack Amazon Clone with an integrated Admin Panel, built using Flutter. This project aims to replicate the core functionalities of Amazon, providing a seamless shopping experience for users and a robust management interface for administrators.

## Features

### User Features

- 🔐 **Authentication**
  - Email & Password Authentication
  - Persisting Auth State
- 🔍 **Product Browsing**
  - Searching Products
  - Filtering Products (Based on Category)
  - Viewing Product Details
- ⭐ **Product Interaction**
  - Rating Products
  - Getting Deal of the Day
- 🛒 **Cart & Checkout**
  - Cart Management
  - Checking out with Google/Apple Pay
- 📦 **Order Management**
  - Viewing My Orders
  - Viewing Order Details & Status
- 👤 **Account Management**
  - Sign Out

### Admin Panel

- 🛠️ **Product Management**
  - Viewing All Products
  - Adding Products
  - Deleting Products
- 📊 **Order Management**
  - Viewing Orders
  - Changing Order Status
- 📈 **Analytics**
  - Viewing Total Earnings and total sales count
  - Viewing Category Based Earnings and sales

### Additional Features

- 📄 **Receipt Generation**
  - Automatic PDF Receipt Generation and Email after Payment
- 🔔 **Notifications**
  - Automatic Notifications to Users via Redis Pub/Sub Model when they click the "Notify Me" button

## Tech Stack

- **Frontend:** Flutter
- **Backend:** Express js, Node js
- **Database:** Mongo DB
- **Payment Integration:** Google Pay
- **Notifications:** Firebase Cloud Messaging, Redis Pub/Sub

## Run Locally

Clone the project

```bash
  git clone https://github.com/nikhil6g/FlutterAmazon
```

Install dependencies

```bash
  flutter pub get
```

```bash
  cd frontend/server
  npm install
```

Create .env file in root/server folder and assign these variables with suitable values

MONGO_URI=
PORT=
JWT_SECRET=
EMAIL_ID=
EMAIL_APP_PASSWORD=
REDIS_URL=
GOOGLE_APPLICATION_CREDENTIALS=

Start the server

```bash
  npm run dev
```

Start the app

```bash
  flutter run
```

## Made By

- [@nikhil](https://github.com/nikhil6g)
