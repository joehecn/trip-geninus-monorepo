<script setup lang="ts">
import { ref } from 'vue';
import { ElForm, ElFormItem, ElInput, ElButton, ElCard } from 'element-plus';

// In a real app, you would import and use the router
// import { useRouter } from 'vue-router';
// const router = useRouter();

const loginForm = ref({
  phone: '',
  password: '',
});

const handleLogin = () => {
  console.log('Login submitted:', loginForm.value);
  // TODO: Call API to login
  // Example:
  // try {
  //   const token = await api.login(loginForm.value);
  //   localStorage.setItem('token', token);
  //   router.push('/');
  // } catch (error) {
  //   console.error('Login failed', error);
  // }
};
</script>

<template>
  <div class="login-container">
    <el-card class="login-card">
      <template #header>
        <div class="card-header">
          <span>后台管理系统登录</span>
        </div>
      </template>
      <el-form :model="loginForm" @submit.prevent="handleLogin">
        <el-form-item label="手机号">
          <el-input v-model="loginForm.phone" placeholder="请输入手机号"></el-input>
        </el-form-item>
        <el-form-item label="密码">
          <el-input v-model="loginForm.password" type="password" placeholder="请输入密码" show-password></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleLogin" native-type="submit" style="width: 100%;">
            登 录
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

.login-card {
  width: 400px;
}

.card-header {
  text-align: center;
  font-size: 1.5rem;
  font-weight: bold;
}
</style>