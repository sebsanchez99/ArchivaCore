import NotFound404 from '@/layouts/error/NotFound404.vue'
import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    // Not found
    {
      path: '/:pathMatch(.*)*',
      component: NotFound404
    },
    // Landing Page
    {
      path: '/',
      name: 'landing',
      component: () => import('@/views/LandingPage.vue'),
    },
    
    // Auth Page
    {
      path: '/auth',
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
    
    // DashboardPage
    {
      path: '/dashboard',
      name: 'dashboard',
      component: () => import('@/views/DashboardPage.vue'),
      children: [
        {
          path: 'home',
          name: 'home',
          component: () => import('@/layouts/dashboard/HomeSection.vue')
        },
        {
          path: 'download',
          name: 'download',
          component: () => import('@/layouts/dashboard/DownloadSection.vue')
        },
        {
          path: 'settings',
          name: 'settings',
          component: () => import('@/layouts/dashboard/SettingsSection.vue')
        },
        {
          path: 'support',
          name: 'support',
          component: () => import('@/layouts/dashboard/SupportSection.vue')
        },
        {
          path: 'plans',
          name: 'plans',
          component: () => import('@/layouts/dashboard/PlansSection.vue')
        }
      ]
    }
    
  ],
})

export default router
