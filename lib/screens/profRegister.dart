import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:cse465ers/services/auth.dart';

class ProfRegister extends StatefulWidget {
  final Function toggleView;
  ProfRegister({this.toggleView});

  @override
  _ProfRegisterState createState() => _ProfRegisterState();
}

class _ProfRegisterState extends State<ProfRegister> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String name = '';
  String surname = '';
  String univercity = '';
  String phoneNumber = '';
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
"Türk-Japon Bilim ve Teknoloji Üniversitesi","Uşak Üniversitesi","Van Yüzüncü Yıl Üniversitesi",
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
"Ostim Teknik Üniversitesi","Özyeğin Üniversitesi","Piri Reis Üniversitesi","Sabancı Üniversitesi","Sanko Üniversitesi","TED Üniversitesi",
"TOBB Ekonomi ve Teknoloji Üniversitesi","Toros Üniversitesi","Türk Hava Kurumu Üniversitesi","Ufuk Üniversitesi","Üsküdar Üniversitesi",
"Yaşar Üniversitesi","Yeditepe Üniversitesi","Yüksek İhtisas Üniversitesi"];

List<String> mails = ["agu.edu.tr","atu.edu.tr","adiyaman.edu.tr","aku.edu.tr","afsu.edu.tr","akdeniz.edu.tr","aksaray.edu.tr","alanya.edu.tr",
"amasya.edu.tr","anadolu.edu.tr","ahbv.edu.tr","mgu.edu.tr","asbu.edu.tr","aybu.edu.tr","ankara.edu.tr","ardahan.edu.tr",
"artvin.edu.tr","atauni.edu.tr","adu.edu.tr","agri.edu.tr","balikesir.edu.tr","bandirma.edu.tr","bartin.edu.tr","batman.edu.tr",
"bayburt.edu.tr","bilecik.edu.tr","bingol.edu.tr","bitliseren.edu.tr","ibu.edu.tr","boun.edu.tr","mehmetakif.edu.tr","btu.edu.tr",
"uludag.edu.tr","comu.edu.tr","karatekin.edu.tr","cu.edu.tr","dicle.edu.tr","deu.edu.tr","duzce.edu.tr","ege.edu.tr","erciyes.edu.tr",
"ebyu.edu.tr","erzurum.edu.tr","ogu.edu.tr","eskisehir.edu.tr","firat.edu.tr","gsu.edu.tr","gazi.edu.tr","gibtu.net","gantep.edu.tr",
"gtu.edu.tr","giresun.edu.tr","gumushane.edu.tr","hacettepe.edu.tr","hakkari.edu.tr","harran.edu.tr","mku.edu.tr","hitit.edu.tr",
"isparta.edu.tr","igdir.edu.tr","inonu.edu.tr","iste.edu.tr","medeniyet.edu.tr","itu.edu.tr","istanbul.edu.tr","istanbulc.edu.tr",
"bakircay.edu.tr","idu.edu.tr","ikc.edu.tr","iyte.edu.tr","kafkas.edu.tr","istiklal.edu.tr","ksu.edu.tr","karabuk.edu.tr",
"ktu.edu.tr","kmu.edu.tr","kastamonu.edu.tr","kayseri.edu.tr","kilis.edu.tr","kocaeli.edu.tr","ktun.edu.tr","dumlupinar.edu.tr",
"ksbu.edu.tr","kku.edu.tr","klu.edu.tr","ahievran.edu.tr","ozal.edu.tr","mcbu.edu.tr","artuklu.edu.tr","marmara.edu.tr",
"mersin.edu.tr","msgsu.edu.tr","mu.edu.tr","munzur.edu.tr","alparslan.edu.tr","erbakan.edu.tr","nevsehir.edu.tr","ohu.edu.tr",
"omu.edu.tr","odu.edu.tr","metu.edu.tr","osmaniye.edu.tr","pau.edu.tr","erdogan.edu.tr","sbu.edu.tr","subu.edu.tr","sakarya.edu.tr",
"samsun.edu.tr","selcuk.edu.tr","siirt.edu.tr","sinop.edu.tr","sivas.edu.tr","cumhuriyet.edu.tr","sdu.edu.tr","sirnak.edu.tr",
"tarsus.edu.tr","nku.edu.tr","gop.edu.tr","trabzon.edu.tr","trakya.edu.tr","tau.edu.tr","tju.edu.tr","usak.edu.tr","yyu.edu.tr",
"yalova.edu.tr","yildiz.edu.tr","bozok.edu.tr","beun.edu.tr","acibadem.edu.tr","ahep.edu.tr","altinbas.edu.tr","anka.edu.tr",
"ankaramedipol.edu.tr","akev.edu.tr","antalya.edu.tr","adiguzel.edu.tr","atilim.edu.tr","avrasya.edu.tr","avrupa.edu.tr",
"bau.edu.tr","baskent.edu.tr","beykent.edu.tr","beykoz.edu.tr","bezmialem.edu.tr","biruni.edu.tr","cag.edu.tr","cankaya.edu.tr",
"dogus.edu.tr","faruksarac.edu.tr","fatihsultan.edu.tr","fbu.edu.tr","halic.edu.tr","hku.edu.tr","isikun.edu.tr","bilkent.edu.tr",
"29mayis.edu.tr","arel.edu.tr","atlas.edu.tr","aydin.edu.tr","ayvansaray.edu.tr","bilgi.edu.tr","istanbulbilim.edu.tr",
"esenyurt.edu.tr","gedik.edu.tr","gelisim.edu.tr","ihu.edu.tr","kent.edu.tr","iku.edu.tr","medipol.edu.tr","okan.edu.tr",
"rumeli.edu.tr","izu.edu.tr","sehir.edu.tr","sisli.edu.tr","ticaret.edu.tr","yeniyuzyil.edu.tr","istinye.edu.tr","ieu.edu.tr",
"tinaztepe.edu.tr","khas.edu.tr","kapadokya.edu.tr","kavram.edu.tr","ku.edu.tr","gidatarim.edu.tr","karatay.edu.tr",
"lokmanhekim.edu.tr","maltepe.edu.tr","mef.edu.tr","nisantasi.edu.tr","nny.edu.tr","ostimteknik.edu.tr","ozyegin.edu.tr",
"pirireis.edu.tr","sabanciuniv.edu","sanko.edu.tr","tedu.edu.tr","etu.edu.tr","toros.edu.tr","thk.org.tr","ufuk.edu.tr",
"uskudar.edu.tr","yasar.edu.tr","yeditepe.edu.tr","yiu.edu.tr"];

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
            SizedBox(height: MediaQuery.of(context).size.height/30,),
            Center(
              child:Text(
                'ERS - Akademisyen Kayıt',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/35,),
            Container(
              color: Color(0xFFD9E6EB),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height/12, 
                                                MediaQuery.of(context).size.height/36, 
                                                MediaQuery.of(context).size.height/12, 
                                                MediaQuery.of(context).size.height/25),
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
                            height: MediaQuery.of(context).size.height/18,
                            child: TextFormField(
                              decoration: new InputDecoration(
                                hintText: '   İsim',
                                suffixIcon: Icon(
                                  Icons.person_outline,
                                  color: Color(0xFF033140),
                                ),
                              ),
                              cursorColor: Color(0xFF033140),
                              validator: (val) => val.isEmpty ? null : null,
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
                              validator: (val) => val.isEmpty ? null : null,
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
                                hintText: '   Telefon',
                                suffixIcon: Icon(
                                  Icons.phone,
                                  color: Color(0xFF033140),
                                ),
                              ),
                              cursorColor: Color(0xFF033140),
                              validator: (val) => val.isEmpty ? null : null,
                              onChanged: (val) {
                                setState(() => phoneNumber = val);
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
                              validator: (val) => val.isEmpty ? null : null,
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
                              validator: (val) => val.length < 6 ? null : null,
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
                      var mail = email.split('@'); // girilen mailin uzantısı var.
                      var u = unis.indexOf(univercity);
                      var m = mails.indexOf(mail[1]);
                      if(u == m){
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _auth.registerProf(email, name, surname, phoneNumber, univercity, password);
                        if(result == null) {
                          setState(() {
                            loading = false;
                          });
                          showAlertDialog(context, "Kayıt Olunamadı! Kaydınız Olabilir.");                          
                        }
                        else{ // Kayıt Olunduysa
                          Navigator.pop(context);
                        }
                      }
                      else{
                        showAlertDialog(context, "Universiteniz ve Mail Uzantınız Eşleşmemektedir !");
                      }
                    }
                    else{ // Formda eksik yerler varsa
                        showAlertDialog(context, "Tüm Alanların Doldurulması Zorunludur. Şifre en az 6 karakter olmalıdır.");
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

  showAlertDialog(BuildContext context, String mes) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(mes),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Tamam"),
              onPressed:  () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}