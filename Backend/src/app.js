const express = require("express");
const cors = require("cors");
const { testConnection, initDatabase } = require("./config/db");
const errorHandler = require("./middleware/errorMiddleware");

const authRoutes = require("./routes/authRoutes");
const startupRoutes = require("./routes/startupRoutes");
const investorRoutes = require("./routes/investorRoutes");
const profileRoutes = require("./routes/profileRoutes");
const roleRoutes = require("./routes/roleRoutes");
const introRoutes = require("./routes/introRoutes");

const app = express();

const initializeApp = async () => {
  const isConnected = await testConnection();
  if (isConnected) {
    await initDatabase();
    console.log("Database ready");
  } else {
    console.error("Failed to connect to database. Exiting...");
    process.exit(1);
  }
};

initializeApp();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(
  cors({
    origin:
      process.env.NODE_ENV === "production" ? process.env.FRONTEND_URL : "*",
    credentials: true,
  }),
);

if (process.env.NODE_ENV === "development") {
  app.use((req, res, next) => {
    console.log(`${req.method} ${req.url} - ${new Date().toISOString()}`);
    next();
  });
}

app.get("/health", (req, res) => {
  res.status(200).json({
    success: true,
    message: "Server is healthy",
    data: {
      timestamp: new Date().toISOString(),
      environment: process.env.NODE_ENV,
    },
  });
});

app.use("/api/auth", authRoutes);
app.use("/api/startups", startupRoutes);
app.use("/api/investor", investorRoutes);
app.use("/api/profile", profileRoutes);
app.use("/api/roles", roleRoutes);
app.use("/api/intros", introRoutes);
app.use((req, res) => {
  res.status(404).json({ message: "Route not found" });
});

app.use(errorHandler);

module.exports = app;
