import request from '@/utils/request'

/**
 * 健康检查
 */
export function healthCheck() {
  return request({
    url: '/test/health',
    method: 'get'
  })
}

/**
 * 获取系统信息
 */
export function getSystemInfo() {
  return request({
    url: '/test/info',
    method: 'get'
  })
}