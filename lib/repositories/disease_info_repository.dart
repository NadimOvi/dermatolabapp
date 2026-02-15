import '../models/disease_info.dart';
import '../utils/constants.dart';

class DiseaseInfoRepository {
  // Mock data for disease information
  // In a real app, this would fetch from an API or local database
  Future<List<DiseaseInfo>> getAllDiseaseInfo() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      DiseaseInfo(
        id: '1',
        name: 'Actinic Keratoses',
        code: 'akiec',
        shortDescription: DiseaseLabels.descriptions['akiec']!,
        fullDescription: '''
Actinic keratoses (AK), also known as solar keratoses, are rough, scaly patches on the skin that develop from years of sun exposure. They're most common in people over 40 who have fair skin.

AKs are considered precancerous lesions, meaning they can potentially develop into skin cancer if left untreated. However, most AKs remain benign, and only a small percentage progress to squamous cell carcinoma.

Early detection and treatment are important to prevent potential complications. Regular skin checks and sun protection are key preventive measures.
''',
        imageUrl: 'https://via.placeholder.com/400x300?text=Actinic+Keratoses',
        symptoms: [
          'Rough, dry, or scaly patches',
          'Flat to slightly raised patches',
          'Color varies from pink to brown',
          'May be itchy or burning',
          'Usually less than 1 inch in diameter',
        ],
        causes: [
          'Prolonged sun exposure',
          'UV radiation from tanning beds',
          'Cumulative sun damage over years',
          'Weakened immune system',
        ],
        riskFactors: [
          'Fair skin, light hair, blue/green eyes',
          'Over 40 years of age',
          'History of frequent sun exposure',
          'Living in sunny climates',
          'History of sunburns',
          'Weakened immune system',
        ],
        severity: 'Moderate',
        lastUpdated: DateTime.now().subtract(const Duration(days: 7)),
      ),
      DiseaseInfo(
        id: '2',
        name: 'Basal Cell Carcinoma',
        code: 'bcc',
        shortDescription: DiseaseLabels.descriptions['bcc']!,
        fullDescription: '''
Basal cell carcinoma (BCC) is the most common form of skin cancer, accounting for about 80% of all skin cancer diagnoses. It develops in the basal cells, which are located in the deepest layer of the epidermis.

BCC grows slowly and rarely spreads (metastasizes) to other parts of the body. However, if left untreated, it can grow deep into the skin and damage surrounding tissue, including bone.

The good news is that BCC is highly treatable, especially when caught early. Treatment options include surgical removal, topical medications, and radiation therapy.
''',
        imageUrl: 'https://via.placeholder.com/400x300?text=Basal+Cell+Carcinoma',
        symptoms: [
          'Pearly or waxy bump',
          'Flat, flesh-colored lesion',
          'Brown or black lesion',
          'Bleeding or oozing sore that heals and returns',
          'Pink growth with raised edges',
        ],
        causes: [
          'UV radiation from sun exposure',
          'UV radiation from tanning beds',
          'Genetic mutations',
        ],
        riskFactors: [
          'Excessive sun exposure',
          'Fair skin',
          'Increasing age',
          'Personal or family history of skin cancer',
          'Weakened immune system',
          'Radiation exposure',
        ],
        severity: 'High',
        lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
      ),
      DiseaseInfo(
        id: '3',
        name: 'Benign Keratosis',
        code: 'bkl',
        shortDescription: DiseaseLabels.descriptions['bkl']!,
        fullDescription: '''
Benign keratosis includes several types of harmless skin growths, most commonly seborrheic keratoses and solar lentigines (age spots). These are non-cancerous and don't require treatment unless they cause discomfort or cosmetic concerns.

Seborrheic keratoses are very common in people over 50 and appear as waxy, stuck-on growths. They can vary in color from light tan to black and may look concerning, but they're completely harmless.

While these lesions don't need treatment, it's important to have any new or changing skin growth checked by a dermatologist to rule out more serious conditions.
''',
        imageUrl: 'https://via.placeholder.com/400x300?text=Benign+Keratosis',
        symptoms: [
          'Waxy, stuck-on appearance',
          'Round or oval shape',
          'Color from tan to black',
          'Slightly raised',
          'May have rough texture',
        ],
        causes: [
          'Aging process',
          'Sun exposure',
          'Genetic factors',
        ],
        riskFactors: [
          'Age over 50',
          'Family history',
          'Fair skin',
        ],
        severity: 'Low',
        lastUpdated: DateTime.now().subtract(const Duration(days: 14)),
      ),
      DiseaseInfo(
        id: '4',
        name: 'Dermatofibroma',
        code: 'df',
        shortDescription: DiseaseLabels.descriptions['df']!,
        fullDescription: '''
Dermatofibroma is a common benign skin growth that appears as a small, firm nodule. These growths are harmless and typically don't require treatment unless they cause symptoms or cosmetic concerns.

The exact cause is unknown, but they may develop after minor skin injuries like insect bites or ingrown hairs. Dermatofibromas are more common in women and usually appear on the legs, though they can occur anywhere on the body.

These growths are permanent but harmless. They may change slightly in color or size over time but rarely cause problems.
''',
        imageUrl: 'https://via.placeholder.com/400x300?text=Dermatofibroma',
        symptoms: [
          'Small, firm nodule',
          'Brown or reddish-brown color',
          'Dimples inward when pinched',
          'May be itchy or tender',
          'Usually 0.5-1 cm in diameter',
        ],
        causes: [
          'Minor skin trauma',
          'Insect bites',
          'Unknown factors',
        ],
        riskFactors: [
          'Female gender',
          'Young to middle-aged adults',
          'History of minor skin injuries',
        ],
        severity: 'Low',
        lastUpdated: DateTime.now().subtract(const Duration(days: 21)),
      ),
      DiseaseInfo(
        id: '5',
        name: 'Melanoma',
        code: 'mel',
        shortDescription: DiseaseLabels.descriptions['mel']!,
        fullDescription: '''
Melanoma is the most serious type of skin cancer. It develops in melanocytes, the cells that produce melanin (skin pigment). While less common than basal cell and squamous cell carcinomas, melanoma is more dangerous because it's more likely to spread to other parts of the body if not caught early.

The good news is that melanoma is highly treatable when detected early. The key is to recognize warning signs and seek prompt medical attention. Regular self-exams and annual skin checks by a dermatologist are crucial.

Early-stage melanoma can often be cured with surgical removal. Advanced melanoma requires more aggressive treatment, including immunotherapy, targeted therapy, chemotherapy, or radiation.
''',
        imageUrl: 'https://via.placeholder.com/400x300?text=Melanoma',
        symptoms: [
          'New mole or changes in existing mole',
          'Asymmetrical shape',
          'Irregular or poorly defined borders',
          'Multiple colors or uneven color',
          'Diameter larger than 6mm',
          'Evolving size, shape, or color',
        ],
        causes: [
          'UV radiation damage',
          'Genetic mutations',
          'Family history',
        ],
        riskFactors: [
          'Excessive sun exposure',
          'History of sunburns',
          'Fair skin',
          'Multiple moles (over 50)',
          'Family history of melanoma',
          'Weakened immune system',
          'Age (risk increases with age)',
        ],
        severity: 'Critical',
        lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
      ),
      DiseaseInfo(
        id: '6',
        name: 'Melanocytic Nevi',
        code: 'nv',
        shortDescription: DiseaseLabels.descriptions['nv']!,
        fullDescription: '''
Melanocytic nevi, commonly known as moles, are benign growths of melanocytes (pigment-producing cells). Most people have between 10-40 moles on their body, and they're usually harmless.

Moles can be present at birth (congenital) or develop over time (acquired). They typically appear during childhood and adolescence, though new moles can develop throughout life. Most moles are stable and don't change significantly over time.

While moles are generally harmless, it's important to monitor them for changes that could indicate melanoma. Use the ABCDE rule: Asymmetry, Border irregularity, Color variation, Diameter over 6mm, and Evolving characteristics.
''',
        imageUrl: 'https://via.placeholder.com/400x300?text=Melanocytic+Nevi',
        symptoms: [
          'Round or oval shape',
          'Uniform color (tan, brown, black)',
          'Flat or slightly raised',
          'Clear, defined borders',
          'Usually less than 6mm diameter',
          'Stable over time',
        ],
        causes: [
          'Genetic factors',
          'Sun exposure',
          'Normal skin development',
        ],
        riskFactors: [
          'Fair skin',
          'Sun exposure during childhood',
          'Family history of multiple moles',
        ],
        severity: 'Low',
        lastUpdated: DateTime.now().subtract(const Duration(days: 10)),
      ),
      DiseaseInfo(
        id: '7',
        name: 'Vascular Lesions',
        code: 'vasc',
        shortDescription: DiseaseLabels.descriptions['vasc']!,
        fullDescription: '''
Vascular lesions are abnormalities of the blood vessels that appear on the skin. They include various conditions such as cherry angiomas, spider veins, port-wine stains, and hemangiomas. Most are benign and don't require treatment unless they cause symptoms or cosmetic concerns.

Cherry angiomas are the most common type and appear as small, bright red bumps. They're harmless and become more common with age. Other vascular lesions may be present from birth or develop over time.

Treatment options are available for cosmetic purposes or if a lesion causes bleeding or other symptoms. These include laser therapy, electrocautery, or cryotherapy.
''',
        imageUrl: 'https://via.placeholder.com/400x300?text=Vascular+Lesions',
        symptoms: [
          'Red, purple, or pink discoloration',
          'Raised or flat appearance',
          'May blanch when pressed',
          'Various sizes',
          'May grow over time',
        ],
        causes: [
          'Genetic factors',
          'Aging',
          'Sun exposure',
          'Hormonal changes',
        ],
        riskFactors: [
          'Increasing age',
          'Fair skin',
          'Pregnancy',
          'Family history',
        ],
        severity: 'Low',
        lastUpdated: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  Future<DiseaseInfo> getDiseaseInfoByCode(String code) async {
    final allInfo = await getAllDiseaseInfo();
    return allInfo.firstWhere(
      (info) => info.code == code,
      orElse: () => throw Exception('Disease info not found for code: $code'),
    );
  }

  Future<List<DiseaseInfo>> getRecentDiseaseInfo({int limit = 5}) async {
    final allInfo = await getAllDiseaseInfo();
    allInfo.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    return allInfo.take(limit).toList();
  }
}
