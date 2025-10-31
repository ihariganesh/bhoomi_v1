#!/bin/bash

echo "🌱 Bhoomi Backend Setup Script"
echo "================================"
echo ""

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed!"
    echo "Install Node.js from: https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js version: $(node --version)"

# Check if MongoDB is installed
if ! command -v mongod &> /dev/null; then
    echo "⚠️  MongoDB is not installed locally"
    echo "You can:"
    echo "  1. Install MongoDB locally"
    echo "  2. Use MongoDB Atlas (cloud - recommended)"
    echo ""
else
    echo "✅ MongoDB installed"
fi

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
npm install

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed successfully"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo ""
    echo "📝 Creating .env file..."
    cp .env.example .env
    
    # Generate JWT secrets
    JWT_SECRET=$(node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")
    JWT_REFRESH_SECRET=$(node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")
    
    # Update .env with generated secrets
    sed -i "s/your-super-secret-jwt-key-change-this-in-production/$JWT_SECRET/" .env
    sed -i "s/your-refresh-token-secret-key/$JWT_REFRESH_SECRET/" .env
    
    echo "✅ .env file created with generated JWT secrets"
    echo ""
    echo "⚠️  IMPORTANT: Edit .env and configure:"
    echo "  - MONGODB_URI (MongoDB connection string)"
    echo "  - CLOUDINARY credentials (for image uploads)"
    echo ""
else
    echo "✅ .env file already exists"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env file: nano .env"
echo "2. Configure MongoDB connection"
echo "3. Start server: npm run dev"
echo ""
echo "Server will run on: http://localhost:5000"
echo "API Docs: http://localhost:5000/api"
echo ""
