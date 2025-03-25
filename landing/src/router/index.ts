import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'landing',
      component: () => import('@/views/LandingPage.vue'),
    },
    
    {
      path: '/auth',
      redirect: '/login',
      component: () => import('@/views/AuthPage.vue'),
      children: [
        {
          path: '/login',
          name: 'login',
          component: () => import('@/layouts/auth/LoginSection.vue')
        },
        {
          path: '/register',
          name: 'register',
          component: () => import('@/layouts/auth/RegisterSection.vue')
        }
      ]
    },

  ],
})

export default router
