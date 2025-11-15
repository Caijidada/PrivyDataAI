<template>
  <div class="home-container">
    <el-container>
      <!-- 头部 -->
      <el-header class="header">
        <div class="header-left">
          <h2> 企业数据智能协作平台</h2>
        </div>
        <div class="header-right">
          <el-button @click="testBackend">测试后端连接</el-button>
          <el-dropdown>
            <span class="user-info">
              <el-icon><User /></el-icon>
              admin
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="handleLogout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>
      
      <!-- 主体 -->
      <el-container>
        <!-- 侧边栏 -->
        <el-aside width="200px" class="aside">
          <el-menu
            default-active="1"
            class="menu"
          >
            <el-menu-item index="1">
              <el-icon><Odometer /></el-icon>
              <span>首页</span>
            </el-menu-item>
            <el-menu-item index="2">
              <el-icon><Connection /></el-icon>
              <span>数据源管理</span>
            </el-menu-item>
            <el-menu-item index="3">
              <el-icon><Search /></el-icon>
              <span>智能查询</span>
            </el-menu-item>
            <el-menu-item index="4">
              <el-icon><Monitor /></el-icon>
              <span>数据看板</span>
            </el-menu-item>
          </el-menu>
        </el-aside>
        
        <!-- 内容区 -->
        <el-main class="main">
          <el-card>
            <h3>欢迎使用企业数据智能协作平台！</h3>
            
            <el-divider />
            
            <div class="info-section">
              <h4>系统信息</h4>
              <div v-if="systemInfo">
                <p><strong>系统名称:</strong> {{ systemInfo.name }}</p>
                <p><strong>版本:</strong> {{ systemInfo.version }}</p>
                <p><strong>作者:</strong> {{ systemInfo.author }}</p>
                <p><strong>Java版本:</strong> {{ systemInfo.javaVersion }}</p>
              </div>
              <el-empty v-else description="点击测试后端连接" />
            </div>
            
            <el-divider />
            
            <div class="quick-start">
              <h4>快速开始</h4>
              <el-steps :active="0" align-center>
                <el-step title="连接数据源" description="配置企业数据库" />
                <el-step title="自然语言查询" description="用中文提问" />
                <el-step title="创建看板" description="可视化展示" />
                <el-step title="团队协作" description="多人实时编辑" />
              </el-steps>
            </div>
          </el-card>
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { healthCheck, getSystemInfo } from '@/api/test'

const router = useRouter()
const systemInfo = ref(null)

const testBackend = async () => {
  try {
    const healthRes = await healthCheck()
    console.log('健康检查:', healthRes)
    
    const infoRes = await getSystemInfo()
    console.log('系统信息:', infoRes)
    
    systemInfo.value = infoRes.data
    
    ElMessage.success('后端连接成功！')
  } catch (error) {
    console.error('连接失败:', error)
    ElMessage.error('后端连接失败，请检查后端是否启动')
  }
}

const handleLogout = () => {
  localStorage.removeItem('token')
  router.push('/login')
  ElMessage.success('已退出登录')
}
</script>

<style scoped>
.home-container {
  height: 100vh;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #fff;
  border-bottom: 1px solid #e8e8e8;
  padding: 0 20px;
}

.header-left h2 {
  margin: 0;
  font-size: 20px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 15px;
}

.user-info {
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 5px;
}

.aside {
  background-color: #fff;
  border-right: 1px solid #e8e8e8;
}

.menu {
  border-right: none;
}

.main {
  background-color: #f5f5f5;
}

.info-section {
  margin: 20px 0;
}

.info-section p {
  margin: 10px 0;
}

.quick-start {
  margin: 20px 0;
}
</style>