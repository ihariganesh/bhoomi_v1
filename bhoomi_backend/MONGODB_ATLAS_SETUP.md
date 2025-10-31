# MongoDB Atlas Setup Guide

## Quick Links
- **Sign Up**: https://www.mongodb.com/cloud/atlas/register
- **Dashboard**: https://cloud.mongodb.com

## Setup Steps (5 minutes)

### 1. Create Account
- Go to MongoDB Atlas website
- Sign up with Google/GitHub (fastest)
- No credit card required

### 2. Create Free Cluster
- Click "Build a Database"
- Select **M0 FREE** tier (512MB storage)
- Choose region: Mumbai or Singapore (fastest for India)
- Cluster name: Cluster0 (default is fine)
- Click "Create Cluster"

### 3. Create Database User
- Go to **Database Access** (left menu)
- Click "Add New Database User"
- Authentication Method: Password
- Username: `bhoomi_admin`
- Password: Click "Autogenerate Secure Password" and **COPY IT**
- Database User Privileges: Atlas Admin
- Click "Add User"

### 4. Setup Network Access
- Go to **Network Access** (left menu)
- Click "Add IP Address"
- Click "Allow Access from Anywhere" (0.0.0.0/0)
  - This allows your app to connect from any location
  - For production, restrict to specific IPs
- Click "Confirm"

### 5. Get Connection String
- Go back to **Database** (left menu)
- Click "Connect" button on your cluster
- Choose "Connect your application"
- Driver: Node.js
- Version: 4.1 or later
- Copy the connection string:
  ```
  mongodb+srv://bhoomi_admin:<password>@cluster0.xxxxx.mongodb.net/
  ```

### 6. Update Connection String
- Replace `<password>` with your actual password from step 3
- Add database name at the end: `/bhoomi`
- Final format:
  ```
  mongodb+srv://bhoomi_admin:YourActualPassword@cluster0.xxxxx.mongodb.net/bhoomi
  ```

## After You Get the Connection String

Paste it in the chat, and I'll automatically:
1. Update the `.env` file
2. Test the connection
3. Start the backend server
4. Show you the API endpoints

## Troubleshooting

### Connection Error?
- Make sure you replaced `<password>` with actual password
- Check Network Access allows 0.0.0.0/0
- Wait 2-3 minutes after creating cluster (it needs time to deploy)

### Forgot Password?
- Go to Database Access
- Click edit (pencil icon) on your user
- Click "Edit Password"
- Generate new password

### Cluster Not Showing?
- Refresh the page
- Wait 2-3 minutes for deployment
- Check your email for confirmation

## What You Get (FREE Forever)
✅ 512MB storage (enough for ~10,000 users)
✅ Unlimited connections
✅ Automated backups
✅ SSL/TLS encryption
✅ 24/7 uptime
✅ No credit card needed

## Need Help?
Just paste any error messages and I'll help you fix them!
