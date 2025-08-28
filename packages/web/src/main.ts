import { createApp } from 'vue';
import App from './App.vue';
import router from './router'; // Import the router
import ElementPlus from 'element-plus'; // Import Element Plus
import 'element-plus/dist/index.css'; // Import Element Plus styles
import './style.css';

const app = createApp(App);

app.use(router); // Use the router
app.use(ElementPlus); // Use Element Plus

app.mount('#app');