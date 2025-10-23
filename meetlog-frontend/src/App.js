import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { AuthProvider } from './context/AuthContext';
import PrivateRoute from './components/PrivateRoute';
import Login from './pages/Login';
import Register from './pages/Register';
import Dashboard from './pages/Dashboard';
import RestaurantList from './pages/RestaurantList';
import RestaurantDetail from './pages/RestaurantDetail';
import RestaurantForm from './pages/RestaurantForm';
import './App.css';

// React Query Client 생성
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      refetchOnWindowFocus: false,
      retry: 1,
      staleTime: 5 * 60 * 1000, // 5분
    },
  },
});

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <AuthProvider>
        <Router>
          <Routes>
            <Route path="/login" element={<Login />} />
            <Route path="/register" element={<Register />} />
            <Route
              path="/"
              element={
                <PrivateRoute>
                  <Dashboard />
                </PrivateRoute>
              }
            />
            <Route
              path="/restaurants"
              element={
                <PrivateRoute>
                  <RestaurantList />
                </PrivateRoute>
              }
            />
            <Route
              path="/restaurants/new"
              element={
                <PrivateRoute>
                  <RestaurantForm />
                </PrivateRoute>
              }
            />
            <Route
              path="/restaurants/:restaurantId"
              element={
                <PrivateRoute>
                  <RestaurantDetail />
                </PrivateRoute>
              }
            />
            <Route
              path="/restaurants/:restaurantId/edit"
              element={
                <PrivateRoute>
                  <RestaurantForm />
                </PrivateRoute>
              }
            />
            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </Router>
      </AuthProvider>
    </QueryClientProvider>
  );
}

export default App;
