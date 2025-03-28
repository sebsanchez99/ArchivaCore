<template>
  <div class="flex flex-col h-screen">
    <!-- Header -->
    <NavBarSection @scrollTo="scrollTo" />
    <!-- Fin Header -->

    <!-- Main -->
    <main class="flex-1 flex-col items-center justify-center pt-6">
      <section id="home">
        <HomeSection />
      </section>
      <section id="features">
        <FeaturesSection />
      </section>
      <section id="pricing">
        <PricingSection />
      </section>
    </main>
    <!-- Fin Main -->

    <!-- Footer -->
    <ContactSection id="contact" />
    <!-- Fin Footer -->
  </div>
</template>

<script setup>
import HomeSection from "@/layouts/landing/HomeSection.vue"; 
import NavBarSection from "@/layouts/landing/NavBarSection.vue";
import FeaturesSection from "@/layouts/landing/FeaturesSection.vue";
import PricingSection from "@/layouts/landing/PricingSection.vue";
import ContactSection from "@/layouts/landing/ContactSection.vue";

const scrollTo = (sectionId) => {
  const section = document.getElementById(sectionId);
  if (section) {
    section.scrollIntoView({ behavior: "smooth" });
  }
};
</script>
