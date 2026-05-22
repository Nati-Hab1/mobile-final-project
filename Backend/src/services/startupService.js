const Startup = require("../models/startupModel");
const Interest = require("../models/interestModel");
const Bookmark = require("../models/bookmarkModel");
const Intro = require("../models/introModel");

const StartupService = {
  async createStartup(ownerId, startupData) {
    const startup = await Startup.create({
      owner_id: ownerId,
      ...startupData,
    });
    return startup;
  },

  async getAllStartups(userId = null) {
    let startups;
    if (userId) {
      startups = await Startup.findAll({ owner_id: userId });
    } else {
      startups = await Startup.findAll();
    }
    return startups;
  },

  async getStartupById(startupId) {
    if (isNaN(startupId) || startupId <= 0) {
      const error = new Error("Invalid startup ID");
      error.statusCode = 400;
      throw error;
    }

    const startup = await Startup.findById(startupId);
    if (!startup) {
      const error = new Error("Startup not found");
      error.statusCode = 404;
      throw error;
    }
    return startup;
  },

  async getMyStartups(req, res, next) {
    try {
      const userId = req.user.id;
      const startups = await StartupService.getAllStartups(userId); // Pass userId to filter

      res.status(200).json({
        success: true,
        message: "Your startups retrieved successfully",
        data: { startups, count: startups.length },
      });
    } catch (error) {
      next(error);
    }
  },

  async updateStartup(startupId, userId, updateData) {
    const isOwner = await Startup.isOwner(startupId, userId);
    if (!isOwner) {
      const error = new Error("Not authorized to update this startup");
      error.statusCode = 403;
      throw error;
    }

    const startup = await Startup.update(startupId, updateData);
    if (!startup) {
      const error = new Error("Startup not found");
      error.statusCode = 404;
      throw error;
    }

    return startup;
  },

  // Delete startup
  async deleteStartup(startupId, userId) {
    // Check ownership
    const isOwner = await Startup.isOwner(startupId, userId);
    if (!isOwner) {
      const error = new Error("Not authorized to delete this startup");
      error.statusCode = 403;
      throw error;
    }

    const startup = await Startup.delete(startupId);
    if (!startup) {
      const error = new Error("Startup not found");
      error.statusCode = 404;
      throw error;
    }

    return { message: "Startup deleted successfully" };
  },

  // Get startup interests (for owner)
  async getStartupInterests(startupId, userId) {
    // Check ownership
    const isOwner = await Startup.isOwner(startupId, userId);
    if (!isOwner) {
      const error = new Error(
        "Not authorized to view interests for this startup",
      );
      error.statusCode = 403;
      throw error;
    }

    const interests = await Interest.findByStartup(startupId);
    return interests;
  },
};

module.exports = StartupService;
