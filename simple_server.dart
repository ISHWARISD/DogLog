import 'dart:convert';
import 'dart:io';

// A more comprehensive mock database for testing
class MockDatabase {
  // Diet information data
  final List<Map<String, dynamic>> _dietInfo = [
    {
      'breed': 'Labrador',
      'age_group': 'Puppy',
      'diet_info': json.encode({
        'recommendation': 'High protein diet',
        'calories': 1200,
        'frequency': '3 times a day',
        'foods': ['Puppy kibble', 'Boiled chicken', 'Fish oil supplements']
      })
    },
    {
      'breed': 'Labrador',
      'age_group': 'Adult',
      'diet_info': json.encode({
        'recommendation': 'Balanced diet',
        'calories': 1000,
        'frequency': '2 times a day',
        'foods': ['Adult dog food', 'Lean protein', 'Vegetables']
      })
    },
    {
      'breed': 'Poodle',
      'age_group': 'Puppy',
      'diet_info': json.encode({
        'recommendation': 'Growth formula',
        'calories': 800,
        'frequency': '4 times a day',
        'foods': ['Small breed puppy food', 'Soft treats', 'Calcium supplements']
      })
    },
    {
      'breed': 'Poodle',
      'age_group': 'Adult',
      'diet_info': json.encode({
        'recommendation': 'Weight control',
        'calories': 700,
        'frequency': '2 times a day',
        'foods': ['Small breed adult food', 'Fresh vegetables', 'Limited treats']
      })
    }
  ];

  // Exercise recommendations data
  final List<Map<String, dynamic>> _exerciseInfo = [
    {
      'breed': 'Labrador',
      'age_group': 'Puppy',
      'exercise_info': json.encode({
        'daily_requirement': '30-45 minutes',
        'recommended_activities': ['Short walks', 'Gentle play', 'Basic training'],
        'warnings': 'Avoid intense exercise until growth plates close',
        'frequency': '2-3 sessions per day'
      })
    },
    {
      'breed': 'Labrador',
      'age_group': 'Adult',
      'exercise_info': json.encode({
        'daily_requirement': '1-2 hours',
        'recommended_activities': ['Walks', 'Running', 'Swimming', 'Fetch'],
        'warnings': 'Monitor in hot weather, prone to overheating',
        'frequency': '2 sessions per day minimum'
      })
    },
    {
      'breed': 'Poodle',
      'age_group': 'Puppy',
      'exercise_info': json.encode({
        'daily_requirement': '20-30 minutes',
        'recommended_activities': ['Indoor play', 'Short walks', 'Mental stimulation'],
        'warnings': 'Avoid jumping from heights',
        'frequency': '3-4 short sessions daily'
      })
    },
    {
      'breed': 'Poodle',
      'age_group': 'Adult',
      'exercise_info': json.encode({
        'daily_requirement': '45-60 minutes',
        'recommended_activities': ['Agility', 'Walks', 'Interactive toys'],
        'warnings': 'Mental stimulation as important as physical',
        'frequency': '2 sessions per day'
      })
    }
  ];

  // Grooming information data
  final List<Map<String, dynamic>> _groomingInfo = [
    {
      'breed': 'Labrador',
      'grooming_info': json.encode({
        'coat_type': 'Double coat, short',
        'brushing': 'Weekly brushing, daily during shedding season',
        'bathing': 'Once every 4-6 weeks',
        'nail_trimming': 'Every 3-4 weeks',
        'ear_cleaning': 'Weekly check and clean',
        'special_needs': 'Prone to ear infections, check regularly'
      })
    },
    {
      'breed': 'Poodle',
      'grooming_info': json.encode({
        'coat_type': 'Curly, continuous growth',
        'brushing': 'Daily brushing to prevent mats',
        'bathing': 'Every 3-4 weeks',
        'nail_trimming': 'Every 2-3 weeks',
        'ear_cleaning': 'Weekly, check for hair in ear canal',
        'special_needs': 'Professional grooming every 4-6 weeks, coat trimming'
      })
    }
  ];

  // Health issues data
  final List<Map<String, dynamic>> _healthInfo = [
    {
      'breed': 'Labrador',
      'health_info': json.encode({
        'common_issues': ['Hip dysplasia', 'Elbow dysplasia', 'PRA', 'Obesity'],
        'recommended_screenings': ['Hip and elbow evaluation', 'Annual eye exam', 'Exercise induced collapse DNA test'],
        'lifespan': '10-12 years',
        'preventative_care': 'Weight management, regular exercise, joint supplements in later years'
      })
    },
    {
      'breed': 'Poodle',
      'health_info': json.encode({
        'common_issues': ['Addison\'s disease', 'Gastric dilation-volvulus', 'Hip dysplasia', 'Epilepsy'],
        'recommended_screenings': ['Hip evaluation', 'Ophthalmologist evaluation', 'PRA DNA test'],
        'lifespan': '12-15 years',
        'preventative_care': 'Dental care, regular check-ups, eye examinations'
      })
    }
  ];

  // Get all breeds
  List<String> getBreeds() {
    final breeds = _dietInfo.map((info) => info['breed'] as String).toSet().toList();
    return breeds;
  }

  // Get age groups for a specific breed
  List<String> getAgeGroups(String breed) {
    final ageGroups = _dietInfo
        .where((info) => info['breed'] == breed)
        .map((info) => info['age_group'] as String)
        .toList();
    return ageGroups;
  }

  // Get diet information
  Map<String, dynamic>? getDietInfo(String breed, String ageGroup) {
    final result = _dietInfo.where(
      (info) => info['breed'] == breed && info['age_group'] == ageGroup
    ).toList();
    
    if (result.isEmpty) {
      return null;
    }
    
    return {'diet_info': json.decode(result[0]['diet_info'])};
  }

  // Get exercise information
  Map<String, dynamic>? getExerciseInfo(String breed, String ageGroup) {
    final result = _exerciseInfo.where(
      (info) => info['breed'] == breed && info['age_group'] == ageGroup
    ).toList();
    
    if (result.isEmpty) {
      return null;
    }
    
    return {'exercise_info': json.decode(result[0]['exercise_info'])};
  }

  // Get grooming information
  Map<String, dynamic>? getGroomingInfo(String breed) {
    final result = _groomingInfo.where(
      (info) => info['breed'] == breed
    ).toList();
    
    if (result.isEmpty) {
      return null;
    }
    
    return {'grooming_info': json.decode(result[0]['grooming_info'])};
  }

  // Get health information
  Map<String, dynamic>? getHealthInfo(String breed) {
    final result = _healthInfo.where(
      (info) => info['breed'] == breed
    ).toList();
    
    if (result.isEmpty) {
      return null;
    }
    
    return {'health_info': json.decode(result[0]['health_info'])};
  }

  // Get all info for a breed
  Map<String, dynamic> getFullBreedProfile(String breed, String ageGroup) {
    Map<String, dynamic> profile = {
      'breed': breed,
      'age_group': ageGroup
    };
    
    final dietInfo = getDietInfo(breed, ageGroup);
    if (dietInfo != null) {
      profile['diet_info'] = dietInfo['diet_info'];
    }
    
    final exerciseInfo = getExerciseInfo(breed, ageGroup);
    if (exerciseInfo != null) {
      profile['exercise_info'] = exerciseInfo['exercise_info'];
    }
    
    final groomingInfo = getGroomingInfo(breed);
    if (groomingInfo != null) {
      profile['grooming_info'] = groomingInfo['grooming_info'];
    }
    
    final healthInfo = getHealthInfo(breed);
    if (healthInfo != null) {
      profile['health_info'] = healthInfo['health_info'];
    }
    
    return profile;
  }
}

void main() async {
  final database = MockDatabase();
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('Server running on localhost:${server.port}');
  print('Test endpoints:');
  print('GET /breeds');
  print('GET /age_groups/{breed}');
  print('GET /diet_info/{breed}/{ageGroup}');
  print('GET /exercise_info/{breed}/{ageGroup}');
  print('GET /grooming_info/{breed}');
  print('GET /health_info/{breed}');
  print('GET /breed_profile/{breed}/{ageGroup}');

  await for (HttpRequest request in server) {
    request.response.headers.add('Content-Type', 'application/json');
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    
    try {
      final pathSegments = request.uri.pathSegments;
      
      if (request.uri.path == '/breeds') {
        final breeds = database.getBreeds();
        request.response.write(json.encode(breeds));
      } 
      else if (pathSegments.length == 2 && pathSegments[0] == 'age_groups') {
        final breed = pathSegments[1];
        final ageGroups = database.getAgeGroups(breed);
        if (ageGroups.isNotEmpty) {
          request.response.write(json.encode(ageGroups));
        } else {
          request.response.statusCode = HttpStatus.notFound;
          request.response.write(json.encode({
            'error': 'No age groups found for $breed'
          }));
        }
      }
      else if (pathSegments.length == 3 && pathSegments[0] == 'diet_info') {
        final breed = pathSegments[1];
        final ageGroup = pathSegments[2];
        
        final dietInfo = database.getDietInfo(breed, ageGroup);
        if (dietInfo != null) {
          request.response.write(json.encode(dietInfo));
        } else {
          request.response.statusCode = HttpStatus.notFound;
          request.response.write(json.encode({
            'error': 'No diet information found for $breed $ageGroup'
          }));
        }
      }
      else if (pathSegments.length == 3 && pathSegments[0] == 'exercise_info') {
        final breed = pathSegments[1];
        final ageGroup = pathSegments[2];
        
        final exerciseInfo = database.getExerciseInfo(breed, ageGroup);
        if (exerciseInfo != null) {
          request.response.write(json.encode(exerciseInfo));
        } else {
          request.response.statusCode = HttpStatus.notFound;
          request.response.write(json.encode({
            'error': 'No exercise information found for $breed $ageGroup'
          }));
        }
      }
      else if (pathSegments.length == 2 && pathSegments[0] == 'grooming_info') {
        final breed = pathSegments[1];
        
        final groomingInfo = database.getGroomingInfo(breed);
        if (groomingInfo != null) {
          request.response.write(json.encode(groomingInfo));
        } else {
          request.response.statusCode = HttpStatus.notFound;
          request.response.write(json.encode({
            'error': 'No grooming information found for $breed'
          }));
        }
      }
      else if (pathSegments.length == 2 && pathSegments[0] == 'health_info') {
        final breed = pathSegments[1];
        
        final healthInfo = database.getHealthInfo(breed);
        if (healthInfo != null) {
          request.response.write(json.encode(healthInfo));
        } else {
          request.response.statusCode = HttpStatus.notFound;
          request.response.write(json.encode({
            'error': 'No health information found for $breed'
          }));
        }
      }
      else if (pathSegments.length == 3 && pathSegments[0] == 'breed_profile') {
        final breed = pathSegments[1];
        final ageGroup = pathSegments[2];
        
        final profile = database.getFullBreedProfile(breed, ageGroup);
        if (profile.length > 2) { // More than just breed and age_group
          request.response.write(json.encode(profile));
        } else {
          request.response.statusCode = HttpStatus.notFound;
          request.response.write(json.encode({
            'error': 'No profile information found for $breed $ageGroup'
          }));
        }
      }
      else {
        request.response.statusCode = HttpStatus.notFound;
        request.response.write(json.encode({
          'error': 'Endpoint not found',
          'available_endpoints': [
            '/breeds', 
            '/age_groups/{breed}',
            '/diet_info/{breed}/{ageGroup}',
            '/exercise_info/{breed}/{ageGroup}',
            '/grooming_info/{breed}',
            '/health_info/{breed}',
            '/breed_profile/{breed}/{ageGroup}'
          ]
        }));
      }
    } catch (e) {
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.write(json.encode({
        'error': 'Internal server error: $e'
      }));
    }
    
    await request.response.close();
  }
}