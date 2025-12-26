const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const Mark = require('./models/Mark');

const app = express();
app.use(cors());
app.use(express.json());

// Teacher: Save Marks
app.post('/api/marks', async (req, res) => {
    const data = await Mark.create(req.body);
    res.status(201).json(data);
});

// Student: Get Marks by Name
app.get('/api/marks/:name', async (req, res) => {
    const data = await Mark.findOne({ studentName: req.params.name });
    if (!data) return res.status(404).send("Student not found");
    res.json(data);
});

mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/students')
    .then(() => app.listen(5000, () => console.log('Node Backend on port 5000')));