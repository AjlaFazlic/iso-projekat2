const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();  // Učitaj environment varijable

const app = express();

// Middleware
app.use(cors());
app.use(bodyParser.json());

// MongoDB konekcija
const MONGO_URL = process.env.MONGO_URL || 'mongodb://mongo:27017/mydatabase'; // Možete promeniti ako koristite MongoDB Atlas

mongoose.connect(MONGO_URL, {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => {
  console.log('Uspješno spojen na MongoDB');
})
.catch((err) => {
  console.error('Greška pri spajanju na MongoDB', err);
});

// Definišemo Goal model
const goalSchema = new mongoose.Schema({
  text: { type: String, required: true }
});

const Goal = mongoose.model('Goal', goalSchema);

// Routes
app.get('/goals', async (req, res) => {
  try {
    const goals = await Goal.find();
    res.json({ goals: goals });
  } catch (err) {
    res.status(500).json({ message: 'Fetching goals failed.' });
  }
});

app.post('/goals', async (req, res) => {
  const goalText = req.body.text;

  const goal = new Goal({ text: goalText });

  try {
    await goal.save();
    res.status(201).json({ message: 'Goal created!', goal: { id: goal._id, text: goal.text } });
  } catch (err) {
    res.status(500).json({ message: 'Creating goal failed.' });
  }
});

app.delete('/goals/:id', async (req, res) => {
  const goalId = req.params.id;

  try {
    
    if (!mongoose.Types.ObjectId.isValid(goalId)) {
      return res.status(400).json({ message: 'Invalid goal ID.' });
    }

    const deletedGoal = await Goal.findByIdAndRemove(goalId);

    if (!deletedGoal) {
      return res.status(404).json({ message: 'Goal not found.' });
    }

    res.status(200).json({ message: 'Goal deleted!' });
  } catch (err) {
    console.error(err); 
    res.status(500).json({ message: 'Deleting goal failed.' });
  }
});

// Pokretanje servera
const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server je pokrenut na portu ${PORT}`);
});


