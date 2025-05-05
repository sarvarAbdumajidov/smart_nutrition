import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../models/meal_model.dart';
import '../provider/providers.dart';

class SaveData extends ConsumerStatefulWidget {
  const SaveData({super.key});

  @override
  ConsumerState<SaveData> createState() => _SaveDataState();
}

class _SaveDataState extends ConsumerState<SaveData> {
  List<Map<dynamic,dynamic>> meals = [
    {

      "id": "",

      "title": "Tovuq donari",

      "imageUrl": "https://img.recraft.ai/lT08pTMZ8_hR8Bw3gr0LN58y6ES5IO1OfwYAM2a4eJc/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/1787adb6-2d9e-4639-bb21-6abc6113896c@jpg",

      "duration": 25,

      "ingredients": "Tovuq go‘shti, lavash noni, sous, salat barglari",

      "steps": "1. Tovuq go‘shtini tuz va ziravorlar bilan marinad qiling. 2. Tovuqni qovuring yoki grilda pishiring. 3. Lavashga salat va sous bilan joylang. 4. Qadoqlang va iste'mol qiling.",

      "category": ["fast_food", "for_athletes"],

      "isVegetarian": false,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": true

    },

    {

      "id": "",

      "title": "Palov",

      "imageUrl": "https://img.recraft.ai/JzJTAFiVQeNsQhuwAJhJSVOuaAo3laXGJKIBIgXKI-k/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/77485c7b-39b6-45b5-81aa-5d345e02f46e@jpg",

      "duration": 90,

      "ingredients": "Go‘sht, guruch, piyoz, sabzi, yog‘, tuz, ziravorlar",

      "steps": "1. Go‘shtni qovuring. 2. Piyoz va sabzini qo‘shing, pishiring. 3. Guruchni yuvib, qo‘shing va suv soling. 4. Guruch pishguncha qovuring va damlang.",

      "category": ["national_dishes", "for_athletes"],

      "isVegetarian": false,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": true

    },

    {

      "id": "",

      "title": "Qaynatilgan tuxum",

      "imageUrl": "https://img.recraft.ai/VFAf5_aeeuGIjlnKkunrlARaR25VAhS1VArJYWks2-U/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/2cf0657d-ba50-4bcb-8e2a-0380e30e580e@jpg",

      "duration": 12,

      "ingredients": "Tuxum, suv, tuz",

      "steps": "1. Tuxumni suvga solib, qaynatib pishiring. 2. Sovutib, tozalang va xizmat qiling.",

      "category": ["fast_food", "for_athletes"],

      "isVegetarian": true,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": true

    },

    {

      "id": "",

      "title": "Qovurilgan kartoshka",

      "imageUrl": "https://img.recraft.ai/H2rvpuQl68JFC4ltEXUd-2ZH9RAdxBv3QxyXLEyx0yQ/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/bcb74f25-47c1-4b59-9559-56cca8fa9e0f@jpg",

      "duration": 20,

      "ingredients": "Kartoshka, yog‘, tuz",

      "steps": "1. Kartoshkani tozalang va kesing. 2. Yog‘da qovuring. 3. Tuz seping va issiq holda xizmat qiling.",

      "category": ["fast_food"],

      "isVegetarian": true,

      "isDiabetes": true,

      "isCalorie": true,

      "isKids": true,

      "isProtein": false

    },

    {

      "id": "",

      "title": "Tuxumli sendvich",

      "imageUrl": "https://img.recraft.ai/76ii0Sr_sjelwu7J65mlN8WUhqC00Euhiv5M5maLw2k/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/ce9f4ca1-8ca0-43ef-8374-eeea4eaada2c@jpg",

      "duration": 15,

      "ingredients": "Non, tuxum, salat barglari, sous",

      "steps": "1. Tuxumni pishiring. 2. Non ustiga sous surting. 3. Tuxum va salatning barglarini qo‘ying. 4. Sendvichni yopib, xizmat qiling.",

      "category": ["fast_food", "for_athletes"],

      "isVegetarian": false,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": true

    },

    {

      "id": "",

      "title": "Qaynatilgan tovuq",

      "imageUrl": "https://img.recraft.ai/Jeu8YyJ05vIQBM_uLqc6ahleX-1qFgAkOTIPZDbM6B0/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/bbc7c962-993b-4453-bd0c-b6fb620f1e7c@jpg",

      "duration": 50,

      "ingredients": "Tovuq, tuz, murch, ziravorlar",

      "steps": "1. Tovuqni tuz va ziravorlar bilan aralashtiring. 2. Suvda qaynatib pishiring. 3. Sovutib, xizmat qiling.",

      "category": ["fast_food", "for_athletes"],

      "isVegetarian": false,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": true

    },

    {

      "id": "",

      "title": "Manti",

      "imageUrl": "https://img.recraft.ai/hF7QkITnPBprIG1FzRzzbbJ75iNhEzZ2m2iZq0BoF-I/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/612b2e0e-d359-42a8-83ba-89bbdac25dbf@jpg",

      "duration": 90,

      "ingredients": "Un, go‘sht, piyoz, tuz, suv",

      "steps": "1. Un va suvdan xamir tayyorlang. 2. Go‘sht va piyozni mayda to‘g‘rang. 3. Xamirni yoyib, go‘shtli aralashma soling. 4. Mantilarni bug‘da pishiring.",

      "category": ["national_dishes", "for_athletes"],

      "isVegetarian": false,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": true

    },

    {

      "id": "",

      "title": "Shurva",

      "imageUrl": "https://img.recraft.ai/5nkhAO1r4CvODR_rEqLOSR74KDzGy_hmDcnHMqTlEQU/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/b393aeeb-7bc8-4a55-a1ba-6f6bcc5e24e5@jpg",

      "duration": 60,

      "ingredients": "Go‘sht, sabzi, piyoz, kartoshka, pomidor, tuz, ziravorlar",

      "steps": "1. Go‘shtni qaynatib oling. 2. Sabzi, piyoz va kartoshkani to‘g‘rang va qo‘shing. 3. Pomidor va ziravorlarni qo‘shib, sho‘rva tayyorlang.",

      "category": ["national_dishes"],

      "isVegetarian": false,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": true

    },

    {

      "id": "",

      "title": "Chuchvara",

      "imageUrl": "https://img.recraft.ai/eobv3YNxN_hT28gkEqMjMQLNwQ3y-T2zMNi-AemqZY0/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/6c00adc8-1afb-4d20-bf4f-ced1e65127f6@jpg",

      "duration": 60,

      "ingredients": "Un, go‘sht, piyoz, tuz, suv",

      "steps": "1. Xamirni yoğiring. 2. Go‘shtli qo‘ymasini tayyorlang. 3. Xamirga solib, dumplings shaklini bering. 4. Qaynatib pishiring.",

      "category": ["national_dishes"],

      "isVegetarian": false,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": true

    },

    {

      "id": "",

      "title": "Somsa",

      "imageUrl": "https://img.recraft.ai/DPof3GJkwCOockzyFkDcFcnfUDs3djmq4MjYwMK6RGQ/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/227633cc-f90f-4d11-b7e5-46bcbb2a0356@jpg",

      "duration": 90,

      "ingredients": "Un, go‘sht, piyoz, yog‘, tuz",

      "steps": "1. Xamir tayyorlang. 2. Go‘sht va piyoz aralashmasini tayyorlang. 3. Xamirga solib, pishiring yoki qovuring.",

      "category": ["national_dishes", "bread_and_pastry_products"],

      "isVegetarian": false,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": true

    },


    {

      "id": "",

      "title": "Mevali salat",

      "imageUrl": "https://img.recraft.ai/CTZP_o1wfpqHM3GntuuFdSW_WdTfcJuOFKpvc327aMk/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/5d7c09b5-dff4-4661-8c0b-e93d3540dba8@jpg",

      "duration": 15,

      "ingredients": "Olma, apelsin, banan, asal, limon sharbati",

      "steps": "1. Mevalarni tozalang va bo‘laklarga kesing. 2. Asal va limon sharbati bilan aralashtiring. 3. Sovutgichda biroz tursin va xizmat qiling.",

      "category": ["fruits", "salads"],

      "isVegetarian": true,

      "isDiabetes": true,

      "isCalorie": false,

      "isKids": true,

      "isProtein": false

    },

    {

      "id": "",

      "title": "Olma va tvorogli desert",

      "imageUrl": "https://img.recraft.ai/4vVUthUxrpmYtFCah47KFN95OEL_3dy0L00rL_0zTlk/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/604c3432-b09f-4d9c-b8fb-150efcc1fa5c@jpg",

      "duration": 30,

      "ingredients": "Olma, tvorog, shakar, vanil",

      "steps": "1. Olmani tozalab, bo‘laklarga kesing. 2. Tvorog va shakarni aralashtiring. 3. Mevalar bilan birga aralashtiring. 4. Sovutgichda damlang.",

      "category": ["fruits", "sweets_and_desserts"],

      "isVegetarian": true,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": true

    },

    {

      "id": "",

      "title": "Mevali kokteyl",

      "imageUrl": "https://img.recraft.ai/5js0Row6IIWZlBaHR4Bghd0Vy09rTQ5CP3WsTa67Dfw/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/f1a3bf06-8532-4816-8a9c-c4aa07008473@jpg",

      "duration": 10,

      "ingredients": "Banan, apelsin sharbati, qulupnay, asal, muz",

      "steps": "1. Barcha ingredientlarni blenderga soling. 2. Yaxshilab aralashtiring. 3. Sovutgichda xizmat qiling.",

      "category": ["fruits", "drinks", "for_athletes"],

      "isVegetarian": true,

      "isDiabetes": true,

      "isCalorie": false,

      "isKids": true,

      "isProtein": false

    },

    {

      "id": "",

      "title": "Mevali smuzi",

      "imageUrl": "https://img.recraft.ai/DkajVa_LqUdxMVXmHhrU8ak6jRXL3aWNTPFWko9ufa0/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/69139659-7a51-497c-97ff-b3ccddc1d3fd@jpg",

      "duration": 10,

      "ingredients": "Apelsin, banan, qulupnay, yogurt, asal",

      "steps": "1. Barcha ingredientlarni blenderda aralashtiring. 2. Qo‘shimcha asal qo‘shing. 3. Sovutgichda xizmat qiling.",

      "category": ["fruits", "drinks", "for_athletes"],

      "isVegetarian": true,

      "isDiabetes": false,

      "isCalorie": false,

      "isKids": true,

      "isProtein": false

    },

    {

      "id": "",

      "title": "Mevali pyure",

      "imageUrl": "https://img.recraft.ai/6S1HQJUCxQaPCit1H2XEandhJMBYJZZ51m4KaW2sSUE/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/2e9437a0-942c-4fa4-a4b4-2b681fa9b53d@jpg",

      "duration": 20,

      "ingredients": "Olma, nok, banan, asal",

      "steps": "1. Mevalarni tozalang va bo‘laklarga kesing. 2. Qaynatib pyure tayyorlang. 3. Asal qo‘shing va yaxshi aralashtiring. 4. Sovitib iste'mol qiling.",

      "category": ["fruits", "for_athletes", "sweets_and_desserts"],

      "isVegetarian": true,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": false

    },

    {

      "id": "",

      "title": "Qulupnay sharbati",

      "imageUrl": "https://img.recraft.ai/PRdwPtnRZANyWXMG5ro6Kw1YeECSCmWWSIuQhu9hJY4/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/d656fb89-d9d5-41c8-947f-5f751db3122c@jpg",

      "duration": 10,

      "ingredients": "Qulupnay, suv, asal",

      "steps": "1. Qulupnayni blenderda aralashtiring. 2. Suv va asal qo‘shing. 3. Sovutib, xizmat qiling.",

      "category": ["drinks", "for_athletes"],

      "isVegetarian": true,

      "isDiabetes": true,

      "isCalorie": false,

      "isKids": true,

      "isProtein": false

    },

    {

      "id": "",

      "title": "Limonli choy",

      "imageUrl": "https://img.recraft.ai/hV_iK1C3Cc6d3rY8v5XnJWuGmXAgTIOwB467DquyD1g/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/f6d50c95-1110-49df-8098-22915377c2ad@jpg",

      "duration": 5,

      "ingredients": "Choy, limon, shakar",

      "steps": "1. Choyni tayyorlang. 2. Limon qo‘shing. 3. Shakar bilan aralashtiring. 4. Issiq bilan xizmat qiling.",

      "category": ["drinks"],

      "isVegetarian": true,

      "isDiabetes": true,

      "isCalorie": false,

      "isKids": true,

      "isProtein": false

    },

    {

      "id": "",

      "title": "Bodom suti smuzi",

      "imageUrl": "https://img.recraft.ai/GYCqJFu7SaqG8Vma2XiNq5raun4ZuQgMmNZfXN7HMpg/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/b43a83f4-18cd-4aee-92e4-15e7a560b84b@jpg",

      "duration": 10,

      "ingredients": "Bodom, sut, asal, muz",

      "steps": "1. Ingredientlarni blenderga soling. 2. Aralashtiring. 3. Sovutib xizmat qiling.",

      "category": ["drinks", "for_athletes"],

      "isVegetarian": true,

      "isDiabetes": false,

      "isCalorie": false,

      "isKids": true,

      "isProtein": true

    },


    {

      "id": "",

      "title": "Pirog",

      "imageUrl": "https://img.recraft.ai/G0-gT2xUr8ijvVPWQRtkBVAjTdA3QwBaHOfplWP7Ck8/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/df4ec0e4-0b8a-4706-84c6-4ef9cc242d45@jpg",

      "duration": 180,

      "ingredients": "Un, suv, tuz, xamirturush",

      "steps": "1. Xamir yoğiring. 2. Nonni tandirda pishiring. 3. Sovutib xizmat qiling.",

      "category": ["bread_and_pastry_products", "national_dishes"],

      "isVegetarian": true,

      "isDiabetes": true,

      "isCalorie": true,

      "isKids": true,

      "isProtein": false

    },


    {

      "id": "",

      "title": "Tvorogli pirog",

      "imageUrl": "https://img.recraft.ai/ci-PY2R8MkqSEIxyhGcKllLb0GE81pcgDevc1gpQpps/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/7cfad5a1-6e56-4665-b354-f6f6e3e8e6d4@jpg",

      "duration": 90,

      "ingredients": "Un, tvorog, tuxum, shakar, sariyog‘",

      "steps": "1. Xamir tayyorlang. 2. Tvorog va shakarni aralashtiring. 3. Xamirga solib pishiring. 4. Sovutib xizmat qiling.",

      "category": ["sweets_and_desserts", "bread_and_pastry_products"],

      "isVegetarian": true,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": false

    },

    {

      "id": "",

      "title": "Shokoladli tort",

      "imageUrl": "https://img.recraft.ai/KybQwkmLk-prNqL4HTxxxxCGQKJKdIseIS-UqxAUOT8/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/89a1a90f-11a8-472f-aa33-83b728068582@jpg",

      "duration": 60,

      "ingredients": "Un, tuxum, shokolad, sut, shakar",

      "steps": "1. Ingredientlarni aralashtiring. 2. Xamir tayyorlab pishiring. 3. Sovutib xizmat qiling.",

      "category": ["sweets_and_desserts"],

      "isVegetarian": true,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": false

    },

    {

      "id": "",

      "title": "Muzqaymoq",

      "imageUrl": "https://img.recraft.ai/L2JFh6i4_tTib3cC-Eelj26NBUZ0mfuwh0H4Yx2IUDA/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/79912f68-bdf0-4b94-b1b6-d93f6655aeb6@jpg",

      "duration": 45,

      "ingredients": "Sut, shakar, vanilin, tuxum, qaymoq",

      "steps": "1. Ingredientlarni aralashtiring. 2. Sovutgichda muzlatib muzqaymoq tayyorlang. 3. Sovuq holda xizmat qiling.",

      "category": ["sweets_and_desserts"],

      "isVegetarian": true,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": false

    },

    {

      "id": "",

      "title": "Yashil salat",

      "imageUrl": "https://img.recraft.ai/ELdu8h4CnpmIfl0hYwYnw7PPciPJqnqjKKuRJt9S6Aw/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/6dfe02ea-6ac5-49c7-bfac-30fda100281c@jpg",

      "duration": 15,

      "ingredients": "Salat barglari, bodring, limon sharbati, tuz",

      "steps": "1. Bodring va salat barglarini tozalang. 2. Limon sharbati va tuz bilan aralashtiring. 3. Sovutgichda biroz tursin va xizmat qiling.",

      "category": ["salads", "greens_and_vegetable_dishes"],

      "isVegetarian": true,

      "isDiabetes": true,

      "isCalorie": false,

      "isKids": true,

      "isProtein": false

    },

    {

      "id": "",

      "title": "Sabzavotli salat",

      "imageUrl": "https://www.recraft.ai/community?imageId=0c5bc851-225d-4580-813c-c659326ca3c3",

      "duration": 10,

      "ingredients": "Bodring, pomidor, sabzi, tuz, sirka",

      "steps": "1. Sabzavotlarni to‘g‘rang. 2. Tuz va sirka bilan aralashtiring. 3. Sovutib xizmat qiling.",

      "category": ["salads", "greens_and_vegetable_dishes"],

      "isVegetarian": true,

      "isDiabetes": true,

      "isCalorie": false,

      "isKids": true,

      "isProtein": false

    },

    {

      "id": "",

      "title": "Sabzavotli ratatuy",

      "imageUrl": "https://img.recraft.ai/5cXFLMAQruAMY6Bg-LvjPKjm2TmUTvfMdEiojK0ftBs/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/72be8d99-f9c5-471f-88f8-514e2da76675@jpg",

      "duration": 60,

      "ingredients": "Qovurilgan sabzavotlar, pomidor sousi, piyoz, sarimsoq",

      "steps": "1. Piyoz va sarimsoqni qovuring. 2. Sabzavotlarni kesing va qo‘shing. 3. Pomidor sousi bilan pishiring. 4. Issiq holda xizmat qiling.",

      "category": ["greens_and_vegetable_dishes", "international_dishes"],

      "isVegetarian": true,

      "isDiabetes": true,

      "isCalorie": false,

      "isKids": true,

      "isProtein": false

    },

    {

      "id": "",

      "title": "Brokoli salati",

      "imageUrl": "https://img.recraft.ai/mowgnYsjKbQTeb1lPOrvSc8DWQdXIcVGp4KlTweVPxU/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/439f6bf0-3400-42ff-a7f9-468455274672@jpg",

      "duration": 15,

      "ingredients": "Brokoli, limon sharbati, tuz, zaytun moyi",

      "steps": "1. Brokolini qaynatib oling. 2. Limon sharbati, tuz va zaytun moyi bilan aralashtiring. 3. Sovutib xizmat qiling.",

      "category": ["salads", "greens_and_vegetable_dishes", "for_athletes"],

      "isVegetarian": true,

      "isDiabetes": true,

      "isCalorie": false,

      "isKids": true,

      "isProtein": true

    },

    {

      "id": "",

      "title": "Xalqaro pizza",

      "imageUrl": "https://img.recraft.ai/gQDqt0rK_X0siODGbS-R_cfYjQTUhb1x4i2OtnKGHP8/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/3240d229-e02f-4d14-8893-d44653b3d1e8@jpg",

      "duration": 40,

      "ingredients": "Un, pomidor sousi, pishloq, kolbasa, qo‘ziqorin",

      "steps": "1. Xamir tayyorlang. 2. Sos va ingredientlarni soling. 3. Pishiring. 4. Issiq holda xizmat qiling.",

      "category": ["international_dishes", "fast_food"],

      "isVegetarian": false,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": true

    },

    {

      "id": "",

      "title": "Spagetti Karbonara",

      "imageUrl": "https://img.recraft.ai/N_SIZ1TktRlSe-SUbStaGriBD0gfNuCdfsQJwF5Gq2I/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/1e31fa2e-f8a8-4509-a461-c918011edcdc@jpg",

      "duration": 30,

      "ingredients": "Spagetti, tuxum, pishloq, pancetta, qora murch",

      "steps": "1. Spagetti pishiring. 2. Tuxum va pishloqni aralashtiring. 3. Pancettani qovuring. 4. Hammasini aralashtirib xizmat qiling.",

      "category": ["international_dishes", "for_athletes"],

      "isVegetarian": false,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": true

    },

    {

      "id": "",

      "title": "Beshbarmak",

      "imageUrl": "https://img.recraft.ai/J8T3gtiBjOGDdVnzN6Q7_8lLTMyqk9oiLwE3_Z2f_dw/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/12f216b1-7bb1-4fe4-8f8c-30fe4416ccb0@jpg",

      "duration": 120,

      "ingredients": "Go‘sht, non, piyoz, tuz, ziravorlar",

      "steps": "1. Go‘shtni qaynatib oling. 2. Nonni bo‘laklab, suvda namlang. 3. Hammasini aralashtirib xizmat qiling.",

      "category": ["national_dishes"],

      "isVegetarian": false,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": false,

      "isProtein": true

    },

    {

      "id": "",

      "title": "Grechka bilan go‘sht",

      "imageUrl": "https://img.recraft.ai/21UOqYaaHw0Ub1kB_P22zNl4fUelQUE1ORLNCUo7QEM/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/386e317b-d521-4261-95b7-aaa3bb16d1f4@jpg",

      "duration": 45,

      "ingredients": "Grechka, go‘sht, piyoz, sabzi, tuz",

      "steps": "1. Go‘shtni qovuring. 2. Grechkani alohida pishiring. 3. Hammasini aralashtirib xizmat qiling.",

      "category": ["national_dishes", "for_athletes"],

      "isVegetarian": false,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": true

    },

    {

      "id": "",

      "title": "Qovurilgan baliq",

      "imageUrl": "https://img.recraft.ai/4vUE8-FqUO9jTAwXTq7VUOUTu3caLt-SPSE2z4Gl-ww/rs:fit:1434:1024:0/q:95/g:no/plain/abs://prod/images/1b03cbe4-b48a-4541-b662-c34daa68caab@jpg",

      "duration": 30,

      "ingredients": "Baliq, limon, tuz, murch, yog‘",

      "steps": "1. Baliqni tozalang va tuz murch bilan aralashtiring. 2. Yog‘da qovuring. 3. Limon bilan xizmat qiling.",

      "category": ["national_dishes", "for_athletes"],

      "isVegetarian": false,

      "isDiabetes": false,

      "isCalorie": true,

      "isKids": true,

      "isProtein": true

    },


  ];


  Future<void> _addNewMeal() async {
    final storage = ref.read(authProvider.notifier);

    for(int i = 0; i < meals.length; i++){
      final meal = Meal(
        id:  DateTime.now().millisecondsSinceEpoch.toString(),
        title: meals[i]['title'],
        imageUrl: meals[i]['imageUrl'],
        duration: meals[i]['duration'],
        ingredients: meals[i]['ingredients'],
        steps: meals[i]['steps'],
        category: meals[i]['category'],
        isVegetarian: meals[i]['isVegetarian'],
        isDiabetes: meals[i]['isDiabetes'],
        isCalorie: meals[i]['isCalorie'],
        isKids: meals[i]['isKids'],
        isProtein: meals[i]['isProtein'],
      );
      await storage.addMeal(meal);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: ()async{
            await _addNewMeal();
          },
          child: Text('Save data mi?'),
        ),
      ),
    );
  }
}
