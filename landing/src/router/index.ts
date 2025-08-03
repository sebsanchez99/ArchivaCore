import NotFound404 from '@/modules/error/NotFound404.vue'
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
          component: () => import('@/modules/auth/layouts/LoginSection.vue')
        },
        {
          path: '/register',
          name: 'register',
          component: () => import('@/modules/auth/layouts/RegisterSection.vue')
        }
      ]
    },
    
    // DashboardPage
    {
      path: '/dashboard',
      name: 'dashboard',
      redirect: '/dashboard/home',
      component: () => import('@/views/DashboardPage.vue'),
      children: [
        {
          path: 'home',
          name: 'home',
          component: () => import('@/modules/dashboard/layouts/HomeSection.vue')
        },
        {
          path: 'download',
          name: 'download',
          component: () => import('@/modules/dashboard/layouts/DownloadSection.vue')
        },
        {
          path: 'settings',
          name: 'settings',
          component: () => import('@/modules/dashboard/layouts/SettingsSection.vue')
        },
        {
          path: 'support',
          name: 'support',
          component: () => import('@/modules/dashboard/layouts/SupportSection.vue')
        },
        {
          path: 'plans',
          name: 'plans',
          component: () => import('@/modules/dashboard/layouts/PlansSection.vue')
        },
        {
          path: 'chat',
          name: 'chat',
          component: () => import('@/modules/dashboard/layouts/ClientsChatSection.vue')
        },
        {
          path: 'clients',
          name: 'clients',
          component: () => import('@/modules/dashboard/layouts/ClientsSection.vue')
        },
        {
          path: 'users',
          name: 'users',
          component: () => import('@/modules/dashboard/layouts/UsersSection.vue')
        },
        {
          path: 'logs',
          name: 'logs',
          component: () => import('@/modules/dashboard/layouts/LogsSection.vue')
        }
      ]
    }
    
  ],
})

export default router
