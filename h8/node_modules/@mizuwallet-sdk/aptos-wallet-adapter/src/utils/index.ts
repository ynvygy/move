/**
 * Check Page is Loaded in Telegram
 */
export const IsTelegram = typeof window != 'undefined' && !!window?.TelegramWebviewProxy;

/**
 * Check Page has Open Link
 */
export const HasOpenLink =
  typeof window != 'undefined' && !!window?.Telegram?.WebApp?.openTelegramLink;

