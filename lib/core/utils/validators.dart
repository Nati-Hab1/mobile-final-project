class Validators {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    
    return null;
  }
  
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }
  
  static String? validateFullName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Full name is required';
    }
    
    if (name.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (name.length > 100) {
      return 'Name cannot exceed 100 characters';
    }
    
    return null;
  }
  
  static String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) {
      return null; // Phone is optional
    }
    
    final phoneRegex = RegExp(r'^[0-9+\-\s()]{8,20}$');
    if (!phoneRegex.hasMatch(phone)) {
      return 'Enter a valid phone number';
    }
    
    return null;
  }
  
  static String? validateStartupTitle(String? title) {
    if (title == null || title.isEmpty) {
      return 'Startup title is required';
    }
    
    if (title.length < 3) {
      return 'Title must be at least 3 characters';
    }
    
    if (title.length > 200) {
      return 'Title cannot exceed 200 characters';
    }
    
    return null;
  }
  
  static String? validateStartupBlurb(String? blurb) {
    if (blurb == null || blurb.isEmpty) {
      return 'Startup description is required';
    }
    
    if (blurb.length < 10) {
      return 'Description must be at least 10 characters';
    }
    
    if (blurb.length > 500) {
      return 'Description cannot exceed 500 characters';
    }
    
    return null;
  }
  
  static String? validateUrl(String? url) {
    if (url == null || url.isEmpty) {
      return null; // URL is optional
    }
    
    final urlRegex = RegExp(r'^(http|https)://[^\s]+$');
    if (!urlRegex.hasMatch(url)) {
      return 'Enter a valid URL (http:// or https://)';
    }
    
    return null;
  }
  
  static String? validateIntroText(String? text) {
    if (text == null || text.isEmpty) {
      return 'Intro message is required';
    }
    
    if (text.length < 10) {
      return 'Message must be at least 10 characters';
    }
    
    if (text.length > 1000) {
      return 'Message cannot exceed 1000 characters';
    }
    
    return null;
  }
}