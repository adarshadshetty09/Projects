import axios from 'axios';

// Change this URL when you switch backends (Node: 5000, Python: 8000, etc.)
const API_BASE_URL = 'http://localhost:5000/api';

export const submitMarks = (data) => axios.post(`${API_BASE_URL}/marks`, data);
export const getStudentMarks = (name) => axios.get(`${API_BASE_URL}/marks/${name}`);