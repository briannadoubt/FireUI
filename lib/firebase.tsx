
import { initializeApp } from "firebase/app";

const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID,
};

const app = initializeApp(firebaseConfig)

import { getAnalytics } from "firebase/analytics";
import { getAuth, connectAuthEmulator } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
import { getPerformance } from "firebase/performance";

const analytics = getAnalytics(app);
const auth = getAuth(app);
const firestore = getFirestore(app);
const perf = getPerformance(app);

if (process.env.NEXT_PUBLIC_FIREBASE_SHOULD_EMULATE_LOCALLY) {
  // According to the docs, if this is set then all the other services will also use the emulator.
  connectAuthEmulator(auth, "http://localhost:9099");
}

export default { app, analytics, auth, firestore, perf };
