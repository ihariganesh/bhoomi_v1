# 🌱 Bhoomi Backend API

Complete backend server for the Bhoomi Sustainability App with MongoDB database.

## 📋 Features

- ✅ User Authentication (JWT + Refresh Tokens)
- ✅ MongoDB Database with Mongoose
- ✅ Travel Session Tracking
- ✅ Carbon Activity Logging
- ✅ Team & Challenge System
- ✅ Verified Impact with Photo Upload
- ✅ Leaderboards
- ✅ Data Sync API
- ✅ Rate Limiting & Security
- ✅ File Upload (Cloudinary)

## 🚀 Quick Start

### Prerequisites
```bash
# Install Node.js (v18 or higher)
node --version

# Install MongoDB
# Option 1: Local MongoDB
sudo pacman -S mongodb-bin  # Arch Linux
# OR
# Option 2: Use MongoDB Atlas (cloud - recommended)
```

### Installation

```bash
# 1. Navigate to backend directory
cd /home/hari/Desktop/pro/bhoomi_backend

# 2. Install dependencies
npm install

# 3. Create environment file
cp .env.example .env

# 4. Edit .env file with your credentials
nano .env
```

### Environment Setup (.env)

```env
NODE_ENV=development
PORT=5000

# Local MongoDB
MONGODB_URI=mongodb://localhost:27017/bhoomi_db

# OR MongoDB Atlas (Cloud)
# MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/bhoomi_db

# JWT Secrets (change these!)
JWT_SECRET=your-secret-key-min-32-characters-long
JWT_EXPIRE=7d
JWT_REFRESH_SECRET=your-refresh-secret-key-min-32-characters
JWT_REFRESH_EXPIRE=30d

# Cloudinary (optional - for image uploads)
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

FRONTEND_URL=http://localhost:8080
```

### Start Server

```bash
# Development mode (with auto-reload)
npm run dev

# Production mode
npm start
```

Server will run on: **http://localhost:5000**

## 📡 API Endpoints

### Authentication
```
POST   /api/auth/register      - Register new user
POST   /api/auth/login         - Login user
POST   /api/auth/refresh       - Refresh access token
POST   /api/auth/logout        - Logout user
GET    /api/auth/me            - Get current user
```

### Users
```
GET    /api/users              - Get all users (paginated)
GET    /api/users/:id          - Get user by ID
PUT    /api/users/:id          - Update user
DELETE /api/users/:id          - Delete user
GET    /api/users/:id/stats    - Get user statistics
```

### Travel Sessions
```
POST   /api/travel             - Create travel session
GET    /api/travel             - Get user's travel sessions
GET    /api/travel/:id         - Get specific travel session
PUT    /api/travel/:id         - Update travel session
DELETE /api/travel/:id         - Delete travel session
GET    /api/travel/stats       - Get travel statistics
```

### Carbon Activities
```
POST   /api/activities         - Log carbon activity
GET    /api/activities         - Get user's activities
GET    /api/activities/:id     - Get specific activity
PUT    /api/activities/:id     - Update activity
DELETE /api/activities/:id     - Delete activity
GET    /api/activities/stats   - Get carbon statistics
```

### Challenges
```
GET    /api/challenges         - Get all challenges
GET    /api/challenges/:id     - Get challenge details
POST   /api/challenges/:id/join - Join challenge
PUT    /api/challenges/:id/progress - Update progress
GET    /api/challenges/my      - Get user's challenges
```

### Teams
```
POST   /api/teams              - Create team
GET    /api/teams              - Get all teams
GET    /api/teams/:id          - Get team details
POST   /api/teams/:id/join     - Join team
DELETE /api/teams/:id/leave    - Leave team
GET    /api/teams/:id/stats    - Get team statistics
```

### Leaderboard
```
GET    /api/leaderboard/users  - User leaderboard
GET    /api/leaderboard/teams  - Team leaderboard
GET    /api/leaderboard/weekly - Weekly rankings
```

### Sync
```
POST   /api/sync/upload        - Upload local data
GET    /api/sync/download      - Download server data
POST   /api/sync/resolve       - Resolve conflicts
```

### File Upload
```
POST   /api/upload/image       - Upload image
POST   /api/upload/verification - Upload verification photo
```

## 🗄️ Database Models

### User
- Authentication & Profile
- Stats (carbon saved, points, level)
- Preferences & Settings
- Teams & Badges

### TravelSession
- GPS tracking data
- Vehicle type & emissions
- Route information
- Carbon calculations

### CarbonActivity
- Activity logging
- Carbon footprint tracking
- Verification system
- Tags & categories

### Team
- Team management
- Members & roles
- Goals & statistics
- Invite system

### Challenge
- Individual & team challenges
- Progress tracking
- Rewards & badges
- Festival campaigns

### VerifiedImpact
- Photo verification
- Location validation
- Community engagement
- Likes & comments

## 🔐 Authentication Flow

```
1. Register/Login → Receive JWT token + Refresh token
2. Include token in headers: Authorization: Bearer <token>
3. Token expires after 7 days → Use refresh token to get new token
4. Refresh token expires after 30 days → User must login again
```

## 🧪 Testing APIs

### Using cURL
```bash
# Register
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123"}'

# Login
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Get current user (with token)
curl -X GET http://localhost:5000/api/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Using Postman
1. Import the collection (coming soon)
2. Set environment variable for token
3. Test all endpoints

## 🚢 Deployment

### Option 1: Railway (Recommended - Free)
```bash
# 1. Install Railway CLI
npm install -g @railway/cli

# 2. Login
railway login

# 3. Initialize project
railway init

# 4. Add MongoDB
railway add mongodb

# 5. Deploy
railway up

# 6. Set environment variables in Railway dashboard
```

### Option 2: Render
1. Push code to GitHub
2. Connect to Render
3. Add MongoDB Atlas connection
4. Deploy

### Option 3: DigitalOcean
1. Create droplet
2. Install Node.js & MongoDB
3. Clone repository
4. Run with PM2

## 📊 MongoDB Atlas Setup (Cloud Database)

1. Go to https://mongodb.com/cloud/atlas
2. Create free account
3. Create cluster (Free M0 tier)
4. Create database user
5. Whitelist IP: 0.0.0.0/0 (allow from anywhere)
6. Get connection string
7. Add to .env file

## 🔧 Project Structure

```
bhoomi_backend/
├── models/              # Database schemas
│   ├── User.js
│   ├── TravelSession.js
│   ├── CarbonActivity.js
│   ├── Team.js
│   ├── Challenge.js
│   └── VerifiedImpact.js
├── routes/              # API routes
│   ├── auth.routes.js
│   ├── user.routes.js
│   ├── travel.routes.js
│   └── ...
├── controllers/         # Business logic (to be created)
├── middleware/          # Auth & validation
│   └── auth.js
├── utils/               # Helper functions
├── config/              # Configuration files
├── server.js            # Entry point
├── package.json
└── .env
```

## 📝 Next Steps

1. **Install Dependencies:**
   ```bash
   cd /home/hari/Desktop/pro/bhoomi_backend
   npm install
   ```

2. **Setup MongoDB:**
   - Install locally OR use MongoDB Atlas
   - Update .env with connection string

3. **Generate JWT Secrets:**
   ```bash
   # Generate random secrets
   node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
   ```

4. **Start Server:**
   ```bash
   npm run dev
   ```

5. **Test API:**
   - Use Postman or cURL
   - Register a test user
   - Login and get token

6. **Connect Flutter App:**
   - Update API base URL
   - Integrate authentication
   - Test data sync

## 🐛 Troubleshooting

### MongoDB Connection Error
```bash
# Check if MongoDB is running
sudo systemctl status mongodb

# Start MongoDB
sudo systemctl start mongodb
```

### Port Already in Use
```bash
# Kill process on port 5000
lsof -ti:5000 | xargs kill -9
```

### JWT Secret Error
- Ensure JWT_SECRET is at least 32 characters
- Generate new secret with crypto

## 📞 Support

For issues or questions:
- Check logs: Server console output
- MongoDB logs: `journalctl -u mongodb`
- Test endpoints with Postman

## 🎉 Ready!

Your backend is ready! Now integrate it with the Flutter app.

API Base URL: **http://localhost:5000/api**
