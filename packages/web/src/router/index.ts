import { createRouter, createWebHistory } from 'vue-router';
import Layout from '../views/Layout.vue';
import Login from '../views/Login.vue';

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: Login,
  },
  {
    path: '/',
    name: 'Layout',
    component: Layout,
    // meta: { requiresAuth: true } 
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// Navigation guard (to be implemented later)
router.beforeEach((to, from, next) => {
  // const isAuthenticated = !!localStorage.getItem('token');
  // if (to.name !== 'Login' && !isAuthenticated) {
  //   next({ name: 'Login' });
  // } else {
  //   next();
  // }
  next();
});

export default router;
