<template>
  <section>
    <div class="product">
      <div class="description">
        <h1>Netsoc Membership</h1>
      </div>
    </div>
    <div v-if="!showingButton">You will be redirected automatically...</div>
    <button
      v-else
      v-on:click="createSession"
      id="checkout-button"
      class="action-button manually-renew-button"
    >
      Try again
    </button>
    <p>{{ errorResponse }}</p>
  </section>
</template>

<script>
export default {
  name: "Renew",
  props: ["uid", "jwt"],
  data() {
    return {
      errorResponse: "",
      showingButton: false,
    };
  },
  methods: {
    createSession() {
      if (this.uid.length < 1) this.$router.push({ name: "Login" });

      // eslint-disable-next-line
      let stripe = Stripe(STRIPE_PUBLIC_KEY);

      // eslint-disable-next-line
      const URL = PAYMENT_CREATE_SESSION_URL;

      let uid = this.uid;
      const axios = require("axios").default;
      axios
        .post(
          URL,
          { uid: uid },
          {
            headers: {
              "Access-Control-Allow-Headers": "Content-Type",
              "Content-Type": "application/json",
            },
          }
        )
        .then((session) => {
          stripe.redirectToCheckout({ sessionId: session.data.id });
        })
        .catch((error) => {
          this.errorResponse = `Error: ${error.response.data.message}`;
        });
    },
  },
  beforeMount() {
    if (this.jwt.length < 1) {
      this.$router.push({ name: "Login" });
    } else if (this.uid.length < 1) {
      this.$router.push({ name: "Account" });
    } else {
      this.createSession();
    }
    setTimeout(() => (this.showingButton = true), 5000);
  },
};
</script>

<style scoped>
.nat-logo {
  max-height: 5rem;
  padding-bottom: 1rem;
  max-width: 100%;
}

.manually-renew-button {
  background-color: rgb(70, 155, 70);
}
</style>
