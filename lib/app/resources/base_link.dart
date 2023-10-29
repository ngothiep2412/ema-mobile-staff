class BaseLink {
  static const localBaseLink = 'http://api.hreaevent.live';
  static const login = '/api/v1/auth/login';
  static const storeDevice = '/api/v1/device';
  static const sendOtp = '/api/v1/auth/send-code';
  static const verifyCode = '/api/v1/auth/verify-code';
  static const resetPassword = '/api/v1/auth/forget-password';
  static const getProfile = '/api/v1/user/profile';
  static const updateProfile = '/api/v1/user/profile';
  static const uploadFile = '/api/v1/file/upload';
  static const getEvent = '/api/v1/event/division';
  static const getTask = '/api/v1/task';
  static const getTaskBySelf = '/api/v1/task/filterByAssignee';
  static const getAssignerInformation = '/api/v1/user/';
  static const updateStatusTask = '/api/v1/task/updateTaskStatus';
  static const updateFileTask = '/api/v1/taskFile';
  static const updateTask = '/api/v1/task/updateTask';
  static const createSubTask = '/api/v1/task/createTask';
  static const createComment = '/api/v1/comment';
  static const getAllEmployee = '/api/v1/user';
  static const assignTask = '/api/v1/assign-task';
  static const getAllComment = '/api/v1/comment';
  static const deleteComment = '/api/v1/comment/';
  static const createBudget = '/api/v1/budget';
  static const getAllBudget = '/api/v1/budget';
  static const updateBudget = '/api/v1/budget/';
  static const getBudgetDetail = '/api/v1/budget/detail/';
}
