abstract final class AuthErrorMapper {
  static String map(String message) {
    final lowerMessage = message.toLowerCase();

    // Supabase Auth Errors
    if (lowerMessage.contains('invalid login credentials')) {
      return 'El correo o la contraseña son incorrectos. Por favor, verifica tus datos.';
    }
    if (lowerMessage.contains('email not confirmed')) {
      return 'Tu cuenta aún no ha sido confirmada. Por favor, revisa tu correo institucional para activarla.';
    }
    if (lowerMessage.contains('user already registered')) {
      return 'Este correo electrónico ya se encuentra registrado. Intenta recuperar tu contraseña o iniciar sesión.';
    }
    if (lowerMessage.contains('password should be at least 6 characters')) {
      return 'Por seguridad, la contraseña debe tener al menos 6 caracteres.';
    }
    if (lowerMessage.contains('invalid email')) {
      return 'El formato del correo electrónico no es válido. Asegúrate de usar tu dirección institucional.';
    }
    
    // Connection Errors
    if (lowerMessage.contains('network') || lowerMessage.contains('timeout') || lowerMessage.contains('failed to host lookup')) {
      return 'Parece que hay un problema con tu conexión a internet. Revisa tu señal e inténtalo de nuevo.';
    }
    
    // Security / Rate Limit
    if (lowerMessage.contains('rate limit') || lowerMessage.contains('too many requests')) {
      return 'Has realizado demasiados intentos en poco tiempo. Por seguridad, espera unos minutos antes de volver a intentarlo.';
    }
    
    // Database / Backend
    if (lowerMessage.contains('profile') && lowerMessage.contains('not found')) {
      return 'No hemos podido encontrar tu perfil académico. Contacta al administrador si el problema persiste.';
    }
    if (lowerMessage.contains('database error') || lowerMessage.contains('postgrest') || lowerMessage.contains('server error')) {
      return 'Lo sentimos, el servidor académico no responde. Estamos trabajando para solucionarlo. Por favor, intenta más tarde.';
    }
    if (lowerMessage.contains('forbidden') || lowerMessage.contains('permission denied')) {
      return 'No tienes permisos suficientes para realizar esta acción.';
    }

    // Default Fallback
    return 'Lo sentimos, ocurrió un problema inesperado. Por favor, verifica tu información o intenta más tarde.';
  }
}
