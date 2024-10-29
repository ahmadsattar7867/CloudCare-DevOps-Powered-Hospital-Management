const express = require("express");
const bodyParser = require("body-parser");
const corsMiddleware = require("./middlewares/cors");
const errorHandlerMiddleware = require("./middlewares/errorHandler");
const connectToDatabase = require("./db/mongoose");
const authController = require("./controllers/authController");
const userController = require("./controllers/userController");
const doctorController = require("./controllers/doctorController");
const nurseController = require("./controllers/nurseController");
const appointmentController = require("./controllers/appointmentController");
const adminController = require("./controllers/adminController");
const limiter = require("./middlewares/rateLimiter");
const config = require("config");

const app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(corsMiddleware);

app.use("/auth", limiter, authController);
app.use("/user", limiter, userController);
app.use("/doctor", limiter, doctorController);
app.use("/nurse", limiter, nurseController);
app.use("/appointment", limiter, appointmentController);
app.use("/admin", limiter, adminController);
app.use(errorHandlerMiddleware);

// Add a root route for the API
app.get('/', (req, res) => {
  res.json({ message: 'Welcome to the Hospital API' });
});

async function startServer() {
  try {
    await connectToDatabase();
    const port = process.env.PORT || 4451;
    const server = app.listen(port, () => {
      console.log(`Server running on port: ${port}`);
    });
    return server;
  } catch (error) {
    console.error("Failed to start the server:", error.message);
    process.exit(1);
  }
}

// Only start the server if this file is run directly
if (require.main === module) {
  startServer();
}

module.exports = app;