import 'package:flutter/material.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:cse465ers/services/auth.dart';
import 'package:dropdownfield/dropdownfield.dart';


class StudentRegister extends StatefulWidget {
  final Function toggleView;
  StudentRegister({ this.toggleView });

  @override
  _StudentRegisterState createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String name = '';
  String surname = '';
  String studentNumber = '';
  String univercity = '';
  String password = '';
  String error = '';

  List<String> unis = ["Abdullah Gül Üniversitesi","Adana Alparslan Türkeş Bilim ve Teknoloji  Üniversitesi","Adıyaman Üniversitesi",
"Afyon Kocatepe Üniversitesi","Afyonkarahisar Sağlık Bilimleri Üniversitesi","Akdeniz Üniversitesi","Aksaray Üniversitesi",
"Alanya Alaaddin Keykubat Üniversitesi","Amasya Üniversitesi","Anadolu Üniversitesi","Ankara Hacı Bayram Veli Üniversitesi",
"Ankara Müzik ve Güzel Sanatlar Üniversitesi","Ankara Sosyal Bilimler Üniversitesi","Ankara Yıldırım Beyazıt Üniversitesi","Ankara Üniversitesi",
"Ardahan Üniversitesi","Artvin Çoruh Üniversitesi","Atatürk Üniversitesi","Aydın Adnan Menderes Üniversitesi","Ağrı İbrahim Çeçen Üniversitesi",
"Balıkesir Üniversitesi","Bandırma Onyedi Eylül Üniversitesi","Bartın Üniversitesi","Batman Üniversitesi","Bayburt Üniversitesi","Bilecik Şeyh Edebali Üniversitesi",
"Bingöl Üniversitesi","Bitlis Eren Üniversitesi","Bolu Abant İzzet Baysal Üniversitesi","Boğaziçi Üniversitesi","Burdur Mehmet Akif Ersoy Üniversitesi",
"Bursa Teknik Üniversitesi","Bursa Uludağ Üniversitesi","Çanakkale Onsekiz Mart Üniversitesi","Çankırı Karatekin Üniversitesi","Çukurova Üniversitesi",
"Dicle Üniversitesi","Dokuz Eylül Üniversitesi","Düzce Üniversitesi","Ege Üniversitesi","Erciyes Üniversitesi","Erzincan Binali Yıldırım Üniversitesi",
"Erzurum Teknik Üniversitesi","Eskişehir Osmangazi Üniversitesi","Eskişehir Teknik Üniversitesi","Fırat Üniversitesi","Galatasaray Üniversitesi","Gazi Üniversitesi",
"Gaziantep Bilim ve Teknoloji Üniversitesi","Gaziantep Üniversitesi","Gebze Teknik Üniversitesi","Giresun Üniversitesi","Gümüşhane Üniversitesi",
"Hacettepe Üniversitesi","Hakkari Üniversitesi","Harran Üniversitesi","Hatay Mustafa Kemal Üniversitesi","Hitit Üniversitesi","Isparta Uygulamalı Bilimler Üniversitesi",
"Iğdır Üniversitesi","İnönü Üniversitesi","İskenderun Tenik Üniversitesi","İstanbul Medeniyet Üniversitesi","İstanbul Teknik Üniversitesi","İstanbul Üniversitesi",
"İstanbul Üniversitesi-Cerrahpaşa","İzmir Bakırçay Üniversitesi","İzmir Demokrasi Üniversitesi","İzmir Katip Çelebi Üniversitesi","İzmir Yüksek Teknoloji Enstitüsü",
"Kafkas Üniversitesi","Kahramanmaraş İstiklal Üniversitesi","Kahramanmaraş Sütçü İmam Üniversitesi","Karabük Üniversitesi","Karadeniz Teknik Üniversitesi",
"Karamanoğlu Mehmetbey Üniversitesi","Kastamonu Üniversitesi","Kayseri Üniversitesi","Kilis 7 Aralık Üniversitesi","Kocaeli Üniversitesi","Konya Teknik Üniversitesi",
"Kütahya Dumlupınar Üniversitesi","Kütahya Sağlık Bilimleri Üniversitesi","Kırıkkale Üniversitesi","Kırklareli Üniversitesi","Kırşehir Ahi Evran Üniversitesi",
"Malatya Turgut Özal Üniversitesi","Manisa Celal Bayar Üniversitesi","Mardin Artuklu Üniversitesi","Marmara Üniversitesi","Mersin Üniversitesi",
"Mimar Sinan Güzel Sanatlar Üniversitesi","Muğla Sıtkı Koçman Üniversitesi","Munzur Üniversitesi","Muş Alparslan Üniversitesi","Necmettin Erbakan Üniversitesi",
"Nevşehir Hacı Bektaş Veli Üniversitesi","Niğde Ömer Halidemir Üniversitesi","Ondokuz Mayıs Üniversitesi","Ordu Üniversitesi","Orta Doğu Teknik Üniversitesi",
"Osmaniye Korkut Ata Üniversitesi","Pamukkale Üniversitesi","Recep Tayyip Erdoğan Üniversitesi","Sağlık Bilimleri Üniversitesi",
"Sakarya Uygulamalı Bilimler Üniversitesi","Sakarya Üniversitesi","Samsun Üniversitesi","Selçuk Üniversitesi","Siirt Üniversitesi","Sinop Üniversitesi",
"Sivas Bilim ve Teknoloji Üniversitesi","Sivas Cumhuriyet Üniversitesi","Süleyman Demirel Üniversitesi","Şırnak Üniversitesi","Tarsus Üniversitesi",
"Tekirdağ Namık Kemal Üniversitesi","Tokat Gaziosmanpaşa Üniversitesi","Trabzon Üniversitesi","Trakya Üniversitesi","Türk-Alman Üniversitesi",
"Türk-Japon Bilim ve Teknoloji Üniversitesi","Türkiye Uluslararası İslam, Bilim ve Teknoloji Üniversitesi","Uşak Üniversitesi","Van Yüzüncü Yıl Üniversitesi",
"Yalova Üniversitesi","Yıldız Teknik Üniversitesi","Yozgat Bozok Üniversitesi","Zonguldak Bülent Ecevit Üniversitesi","Acıbadem Mehmet Ali Aydınlar Üniversitesi",
"Alanya Hamdullah Emin Paşa Üniversitesi","Altınbaş Üniversitesi","Anka Teknoloji Üniversitesi","Ankara Medipol Üniversitesi","Antalya AKEV Üniversitesi",
"Antalya Bilim Üniversitesi","Ataşehir Adıgüzel Meslek Yüksekokulu","Atılım Üniversitesi","Avrasya Üniversitesi","Avrupa Meslek Yüksekokulu","Bahçeşehir Üniversitesi",
"Başkent Üniversitesi","Beykent Üniversitesi","Beykoz Üniversitesi","Bezmiâlem Vakıf Üniversitesi","Biruni Üniversitesi","Çağ Üniversitesi","Çankaya Üniversitesi",
"Doğuş Üniversitesi","Faruk Saraç Tasarım Meslek Yüksekokulu","Fatih Sultan Mehmet Vakıf Üniversitesi","Fenerbahçe Üniversitesi","Haliç Üniversitesi","Hasan Kalyoncu Üniversitesi",
"Işık Üniversitesi","İhsan Doğramacı Bilkent Üniversitesi","İstanbul 29 Mayıs Üniversitesi","İstanbul Arel Üniversitesi","İstanbul Atlas Üniversitesi","İstanbul Aydın Üniversitesi",
"İstanbul Ayvansaray Üniversitesi","İstanbul Bilgi Üniversitesi","İstanbul Bilim Üniversitesi","İstanbul Esenyurt Üniversitesi","İstanbul Gedik Üniversitesi",
"İstanbul Gelişim Üniversitesi","İstanbul İbn Haldun Üniversitesi","İstanbul Kent Üniversitesi","İstanbul Kültür Üniversitesi","İstanbul Medipol Üniversitesi",
"İstanbul Okan Üniversitesi","İstanbul Rumeli Üniversitesi","İstanbul Sabahattin Zaim Üniversitesi","İstanbul Şehir Üniversitesi",
"İstanbul Şişli Meslek Yüksekokulu","İstanbul Ticaret Üniversitesi","İstanbul Yeni Yüzyıl Üniversitesi","İstinye Üniversitesi","İzmir Ekonomi Üniversitesi",
"İzmir Tınaztepe Üniversitesi","Kadir Has Üniversitesi","Kapadokya Üniversitesi","Kavram Meslek Yüksekokulu","Koç Üniversitesi","Konya Gıda ve Tarım Üniversitesi",
"KTO Karatay Üniversitesi","Lokman Hekim Üniversitesi","Maltepe Üniversitesi","MEF Üniversitesi","Nişantaşı Üniversitesi","Nuh Naci Yazgan Üniversitesi",
"Ostim Teknik Üniversitesi","Özyeğin Üniversitesi","Piri Reis Üniversitesi","Sabancı Üniversitesi","Sanko Üniversitesi","Semerkand Bilim ve Medeniyet Üniversitesi",
"TED Üniversitesi","TOBB Ekonomi ve Teknoloji Üniversitesi","Toros Üniversitesi","Türk Hava Kurumu Üniversitesi","Ufuk Üniversitesi","Üsküdar Üniversitesi",
"Yaşar Üniversitesi","Yeditepe Üniversitesi","Yüksek İhtisas Üniversitesi"];

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Color(0xFF033140),
      body: Container(
        child: ListView(
          children: <Widget>[
            Image(
              image: AssetImage('assets/logIn.png'),
              height: MediaQuery.of(context).size.height/5,
            ),
            SizedBox(height: MediaQuery.of(context).size.height/40,),
            Center(
              child:Text(
                'ERS - Öğrenci Kayıt',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/40,),
            Container(
              color: Color(0xFFD9E6EB),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height/12, 
                                                MediaQuery.of(context).size.height/36, 
                                                MediaQuery.of(context).size.height/12, 
                                                MediaQuery.of(context).size.height/20),
                    decoration: new BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: MediaQuery.of(context).size.width/80,  
                        style: BorderStyle.solid,
                      ),
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(Radius.circular(50.0)),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: MediaQuery.of(context).size.height/45),
                          Container(
                            height: MediaQuery.of(context).size.height/15,
                            child: TextFormField(
                              decoration: new InputDecoration(
                                hintText: '   İsim',
                                suffixIcon: Icon(
                                  Icons.person_outline,
                                  color: Color(0xFF033140),
                                ),
                              ),
                              cursorColor: Color(0xFF033140),
                              validator: (val) => val.isEmpty ? 'Lütfen İsim Giriniz' : null,
                              onChanged: (val) {
                                setState(() => name = val);
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/70),
                          Container(
                            height: MediaQuery.of(context).size.height/18,
                            child: TextFormField(
                              decoration: new InputDecoration(
                                hintText: '   Soyisim',
                                suffixIcon: Icon(
                                  Icons.person_outline,
                                  color: Color(0xFF033140),
                                ),
                              ),
                              cursorColor: Color(0xFF033140),
                              validator: (val) => val.isEmpty ? 'Lütfen Soyisim Giriniz' : null,
                              onChanged: (val) {
                                setState(() => surname = val);
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/70),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                DropDownField(
                                  onValueChanged: (dynamic value){
                                    univercity = value;
                                  },
                                  setter: (dynamic newValue) {
                                      univercity = newValue;
                                  },
                                  value: univercity,
                                  required: true,
                                  strict: true,
                                  hintText: 'Üniversi Seç',
                                  labelText: 'Üniversite',
                                  items: unis,
                                )
                              ],
                            )
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/70),
                          Container(
                            height: MediaQuery.of(context).size.height/18,
                            child: TextFormField(
                              decoration: new InputDecoration(
                                hintText: '   Öğrenci Numarası',
                                suffixIcon: Icon(
                                  Icons.phone,
                                  color: Color(0xFF033140),
                                ),
                              ),
                              cursorColor: Color(0xFF033140),
                              validator: (val) => val.isEmpty ? 'Lütfen Öğrenci Numarası Giriniz' : null,
                              onChanged: (val) {
                                setState(() => studentNumber = val);
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/70),
                          Container(
                            height: MediaQuery.of(context).size.height/18,
                            child: TextFormField(
                              decoration: new InputDecoration(
                                hintText: '   Kullanıcı Maili',
                                suffixIcon: Icon(
                                  Icons.mail_outline,
                                  color: Color(0xFF033140),
                                ),
                              ),
                              cursorColor: Color(0xFF033140),
                              validator: (val) => val.isEmpty ? 'Lütfen Mail Giriniz' : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/70),
                          Container(
                            height: MediaQuery.of(context).size.height/18,
                            child: TextFormField(
                              decoration: new InputDecoration(
                                hintText: '   Şifre',
                                suffixIcon: Icon(
                                  Icons.info_outline,
                                  color: Color(0xFF033140),
                                ),
                              ),
                              obscureText: true,
                              cursorColor: Color(0xFF033140),
                              validator: (val) => val.length < 6 ? 'Şifre En Az 6 Karakter Olmalı' : null,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                          ),
                          SizedBox(height:MediaQuery.of(context).size.height/45),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Color(0xFF033140),
          height: MediaQuery.of(context).size.height/15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: BackButton(
                  color: Colors.white,
                  onPressed: () async {
                    Navigator.pop(context);
                  }
                ),
              ),
              Expanded(
                flex: 3,
                child: RaisedButton(
                  color: Color(0xFF033140),
                  child: Container(
                    width: 100.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.create,
                          color: Colors.white,
                        ),
                        SizedBox(width:MediaQuery.of(context).size.width/100),
                        Text(
                          'Kayıt Ol',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      setState(() => loading = true);
                      dynamic result = await _auth.registerStudent(email, name, surname, studentNumber, univercity, password);
                      if(result == null) {
                        setState(() {
                          error = 'Lütfen Geçerli Bir Mail Giriniz';
                          loading = false;
                        });
                      }
                      Navigator.pop(context);
                    }
                  }
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              )
            ],
          ),
        )
      ),
      
    );
  }
}