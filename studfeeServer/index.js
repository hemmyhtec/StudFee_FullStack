require("dotenv").config();

const express = require("express");
const cors = require("cors");
const path = require('path');
const morgan = require("morgan");
const bodyParser = require("body-parser");
const connectDB = require("./config/config");
const routes = require("./routes/router");
const socket = require("./controller/socket");
const http = require("http");
const cookieParser = require("cookie-parser");

const app = express();
const server = http.createServer(app);
socket(server);

let PORT = process.env.PORT || 3000;
connectDB();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(cookieParser());

app.use(express.static('public'));

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');


if (process.env.NODE_ENV === "development") {
  app.use(morgan("dev"));
}

app.use(routes);

app.listen(PORT, '0.0.0.0', () =>
  console.log("Server listening on http://localhost" + PORT + "/")
);
