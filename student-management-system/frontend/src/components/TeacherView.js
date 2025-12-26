import React, { useState } from 'react';
import { submitMarks } from '../api';
import { Save, UserPlus, BookOpen } from 'lucide-react';

export default function TeacherView() {
  const [form, setForm] = useState({ name: '', math: '', science: '', english: '' });

  const handleSave = async (e) => {
    e.preventDefault();
    try {
      await submitMarks(form);
      alert('Student data pushed to backend successfully!');
      setForm({ name: '', math: '', science: '', english: '' });
    } catch (err) {
      alert('Backend connection failed. Is Node.js running?');
    }
  };

  return (
    <div className="max-w-xl mx-auto bg-white p-8 rounded-[2rem] shadow-2xl shadow-slate-200 border border-slate-100">
      <div className="flex items-center gap-3 mb-8">
        <div className="p-3 bg-indigo-600 rounded-xl text-white shadow-lg shadow-indigo-200">
          <BookOpen size={24} />
        </div>
        <h2 className="text-2xl font-bold">Upload Student Marks</h2>
      </div>

      <form onSubmit={handleSave} className="space-y-6">
        <div>
          <label className="block text-sm font-bold text-slate-700 mb-2">Full Name</label>
          <div className="relative">
            <UserPlus className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
            <input 
              className="w-full pl-12 pr-4 py-4 bg-slate-50 border-none rounded-2xl focus:ring-2 focus:ring-indigo-500 transition-all outline-none"
              placeholder="Enter student name..."
              value={form.name} onChange={e => setForm({...form, name: e.target.value})}
              required
            />
          </div>
        </div>

        <div className="grid grid-cols-3 gap-4">
          {['Math', 'Science', 'English'].map(sub => (
            <div key={sub}>
              <label className="block text-xs font-black uppercase tracking-widest text-slate-400 mb-2">{sub}</label>
              <input 
                type="number" 
                className="w-full p-4 bg-slate-50 border-none rounded-2xl focus:ring-2 focus:ring-indigo-500 outline-none text-center font-bold"
                value={form[sub.toLowerCase()]} 
                onChange={e => setForm({...form, [sub.toLowerCase()]: e.target.value})}
                required
              />
            </div>
          ))}
        </div>

        <button className="w-full bg-slate-900 text-white py-4 rounded-2xl font-bold hover:bg-indigo-600 transition-all flex items-center justify-center gap-2 shadow-lg shadow-slate-200">
          <Save size={20} /> Record Marks
        </button>
      </form>
    </div>
  );
}