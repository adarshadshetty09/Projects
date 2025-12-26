import React, { useState } from 'react';
import TeacherView from './components/TeacherView';
import StudentView from './components/StudentView';
import { School, UserCircle, GraduationCap, ChevronLeft } from 'lucide-react';

function App() {
  const [role, setRole] = useState(null); // 'teacher' or 'student'

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-indigo-50 font-sans text-slate-900">
      {/* Dynamic Header */}
      <nav className="p-6 flex justify-between items-center max-w-6xl mx-auto">
        <div className="flex items-center gap-2 cursor-pointer" onClick={() => setRole(null)}>
          <div className="bg-indigo-600 p-2 rounded-lg text-white">
            <School size={24} />
          </div>
          <h1 className="text-xl font-bold tracking-tight text-slate-800">EduPortal</h1>
        </div>
        {role && (
          <button 
            onClick={() => setRole(null)}
            className="flex items-center gap-2 text-sm font-medium text-slate-500 hover:text-indigo-600 transition-colors"
          >
            <ChevronLeft size={16} /> Back to Selection
          </button>
        )}
      </nav>

      <main className="max-w-6xl mx-auto px-6 py-12">
        {!role ? (
          <div className="flex flex-col items-center">
            <div className="text-center mb-12">
              <h2 className="text-4xl font-extrabold text-slate-900 mb-4">Welcome to Academic Hub</h2>
              <p className="text-slate-500 max-w-md">Please select your portal to continue. Manage marks as a teacher or check performance as a student.</p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-8 w-full max-w-3xl">
              {/* Teacher Card */}
              <button 
                onClick={() => setRole('teacher')}
                className="group bg-white p-10 rounded-3xl shadow-sm border border-slate-200 hover:border-indigo-500 hover:shadow-xl hover:shadow-indigo-100 transition-all text-center"
              >
                <div className="w-20 h-20 bg-indigo-50 rounded-2xl flex items-center justify-center mx-auto mb-6 group-hover:bg-indigo-600 group-hover:text-white transition-colors">
                  <UserCircle size={40} />
                </div>
                <h3 className="text-2xl font-bold mb-2">Teacher Portal</h3>
                <p className="text-slate-500 text-sm">Input student names, subjects, and maintain the database.</p>
              </button>

              {/* Student Card */}
              <button 
                onClick={() => setRole('student')}
                className="group bg-white p-10 rounded-3xl shadow-sm border border-slate-200 hover:border-emerald-500 hover:shadow-xl hover:shadow-emerald-100 transition-all text-center"
              >
                <div className="w-20 h-20 bg-emerald-50 rounded-2xl flex items-center justify-center mx-auto mb-6 group-hover:bg-emerald-600 group-hover:text-white transition-colors">
                  <GraduationCap size={40} />
                </div>
                <h3 className="text-2xl font-bold mb-2">Student Portal</h3>
                <p className="text-slate-500 text-sm">Enter your name to instantly view your subject-wise marks.</p>
              </button>
            </div>
          </div>
        ) : (
          <div className="animate-in fade-in slide-in-from-bottom-4 duration-500">
            {role === 'teacher' ? <TeacherView /> : <StudentView />}
          </div>
        )}
      </main>
    </div>
  );
}

export default App;