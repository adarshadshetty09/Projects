import React, { useState } from 'react';
import { getStudentMarks } from '../api';
import { Search, Trophy } from 'lucide-react';

export default function StudentView() {
  const [name, setName] = useState('');
  const [data, setData] = useState(null);

  const handleSearch = async (e) => {
    e.preventDefault();
    try {
      const res = await getStudentMarks(name);
      setData(res.data);
    } catch (err) {
      alert('Student record not found.');
    }
  };

  return (
    <div className="max-w-2xl mx-auto">
      <form onSubmit={handleSearch} className="relative group mb-12">
        <Search className="absolute left-6 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-emerald-500 transition-colors" size={24} />
        <input 
          className="w-full pl-16 pr-6 py-6 bg-white rounded-full shadow-xl border border-transparent focus:border-emerald-500 outline-none text-lg transition-all"
          placeholder="Search your name..."
          value={name} onChange={e => setName(e.target.value)}
        />
        <button className="absolute right-3 top-1/2 -translate-y-1/2 bg-emerald-600 text-white px-8 py-3 rounded-full font-bold hover:bg-emerald-700 transition-colors shadow-lg shadow-emerald-100">
          Find Results
        </button>
      </form>

      {data && (
        <div className="bg-white p-10 rounded-[2.5rem] shadow-2xl border border-emerald-50 relative overflow-hidden">
          <div className="absolute top-0 right-0 p-8 text-emerald-100 opacity-20">
            <Trophy size={120} />
          </div>
          
          <div className="relative">
            <h3 className="text-sm uppercase tracking-widest font-black text-emerald-600 mb-2">Academic Achievement</h3>
            <h2 className="text-4xl font-black text-slate-800 mb-8">{data.studentName}</h2>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {[
                { label: 'Mathematics', score: data.math, bg: 'bg-blue-50', text: 'text-blue-700' },
                { label: 'Science', score: data.science, bg: 'bg-purple-50', text: 'text-purple-700' },
                { label: 'English', score: data.english, bg: 'bg-orange-50', text: 'text-orange-700' },
              ].map(item => (
                <div key={item.label} className={`${item.bg} p-6 rounded-3xl text-center`}>
                  <p className="text-xs font-bold text-slate-500 uppercase mb-1">{item.label}</p>
                  <p className={`text-3xl font-black ${item.text}`}>{item.score}</p>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}