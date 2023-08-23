const { Server } = require("socket.io");
const Message = require("../models/Message");

function socket(server) {
  const io = new Server(server, {
    cors: {
      origin: "*",
    },
  });

  io.on("connection", (socket) => {
    console.log(`Socket connected: ${socket.id}`);

    socket.on("join", (data) => {
      console.log(`User joined: ${data.sender}`);
      socket.join(data.sender);
    });

    socket.on("message", async (data) => {
      console.log(`Message received: ${data.sender} to ${data.receiver}`);
      const message = new Message({
        sender: data.sender,
        receiver: data.receiver,
        message: data.message,
        createdAt: Date.now(),
        media: data.media,
      });
      await message.save();
      socket.to(data.receiver).emit("message", message);
    });

    socket.on("disconnect", () => {
      console.log(`Socket disconnected ${socket.id}`);
    });
  });
}

module.exports = socket;
