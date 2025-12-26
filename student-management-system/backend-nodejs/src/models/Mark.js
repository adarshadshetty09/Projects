const mongoose = require('mongoose');

const MarkSchema = new mongoose.Schema({
    studentName: { type: String, required: true },
    math: Number,
    science: Number,
    english: Number,
    teacherName: String
});

module.exports = mongoose.model('Mark', MarkSchema);