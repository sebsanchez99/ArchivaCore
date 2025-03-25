<template>
    <div class="flex flex-col h-screen">
      <!-- Header -->
      <NavBarSection/>
      <!-- Fin Header -->
  
      <!-- Main -->
      <main class="flex-1 flex-col items-center justify-center py-6">
        <HomeSection/>
        <FeaturesSection/>
        <PricingSection/>
      </main>
      <!-- Fin Main -->
  
      <!-- Footer -->
      <ContactSection/>
      <!-- Fin Footer -->
    </div>
  </template>
  
  <script lang="ts" setup>
  import HomeSection from "@/layouts/HomeSection.vue"; 
  import NavBarSection from "@/layouts/NavBarSection.vue";
  import FeaturesSection from "@/layouts/FeaturesSection.vue";
  import PricingSection from "@/layouts/PricingSection.vue";
  import ContactSection from "@/layouts/ContactSection.vue";
  </script>
  