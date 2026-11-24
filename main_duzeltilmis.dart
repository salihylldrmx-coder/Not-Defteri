import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

const String uygulamaAdi = 'MEMORA';
const String surum = 'beta 1.0.2';

// ---------- RENKLER ----------

const Color anaMavi = Color(0xFF2563EB);
const Color koyuMavi = Color(0xFF0B1F4B);
const Color acikMavi = Color(0xFFEAF1FF);
const Color zeminRenk = Color(0xFFF5F8FF);
const Color cizgiRenk = Color(0xFFDCE6FA);

const Map<String, int> yaziRenkleri = {
  'Kırmızı': 0xFFD32F2F,
  'Mavi': 0xFF2563EB,
  'Yeşil': 0xFF2E7D32,
  'Turuncu': 0xFFEF6C00,
  'Mor': 0xFF7B1FA2,
  'Gri': 0xFF757575,
};

const Map<String, int> vurguRenkleri = {
  'Sarı': 0xFFFFF176,
  'Yeşil': 0xFFA5D6A7,
  'Pembe': 0xFFF8BBD0,
  'Mavi': 0xFF90CAF9,
};

const List<TextAlign> hizalar = [
  TextAlign.left,
  TextAlign.center,
  TextAlign.right,
];

ThemeData temaOlustur() {
  final sema = ColorScheme.fromSeed(seedColor: anaMavi).copyWith(
    primary: anaMavi,
    onPrimary: Colors.white,
    primaryContainer: acikMavi,
    onPrimaryContainer: koyuMavi,
    surface: Colors.white,
    onSurface: koyuMavi,
    onSurfaceVariant: const Color(0xFF5B6B8C),
    outline: const Color(0xFFB8C7E6),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: sema,
    scaffoldBackgroundColor: zeminRenk,
    appBarTheme: const AppBarTheme(
      backgroundColor: koyuMavi,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: 3,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: anaMavi,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: anaMavi,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerTheme: const DividerThemeData(
      color: cizgiRenk,
      space: 1,
      thickness: 1,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: koyuMavi,
      contentTextStyle: const TextStyle(color: Colors.white),
      actionTextColor: const Color(0xFF7FB0FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

InputDecoration girdiStili(String etiket, IconData ikon, {Widget? sonek}) {
  return InputDecoration(
    labelText: etiket,
    prefixIcon: Icon(ikon),
    suffixIcon: sonek,
    filled: true,
    fillColor: acikMavi,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: anaMavi, width: 1.5),
    ),
  );
}

Widget kartSatir(Widget cocuk) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: cizgiRenk),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Material(color: Colors.white, child: cocuk),
    ),
  );
}

Widget kart(Widget cocuk) {
  return Card(
    color: Colors.white,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: cizgiRenk),
    ),
    child: cocuk,
  );
}

Widget bosDurum(IconData ikon, String metin) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(ikon, size: 56, color: const Color(0xFFB8C7E6)),
        const SizedBox(height: 12),
        Text(
          metin,
          style: const TextStyle(color: Color(0xFF5B6B8C), fontSize: 15),
        ),
      ],
    ),
  );
}

Widget grupChip(String ad, bool aktif, VoidCallback tikla) {
  return ChoiceChip(
    label: Text(
      ad,
      style: TextStyle(
        color: aktif ? Colors.white : koyuMavi,
        fontWeight: FontWeight.w600,
      ),
    ),
    selected: aktif,
    showCheckmark: false,
    selectedColor: anaMavi,
    backgroundColor: Colors.white,
    side: BorderSide(color: aktif ? anaMavi : const Color(0xFFB8C7E6)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    onSelected: (_) => tikla(),
  );
}

// ---------- VERİ ----------

class Adim {
  String baslik;
  bool tamam;

  Adim(this.baslik, {this.tamam = false});
}

class Gorev {
  String baslik;
  String grup;
  bool tamamlandi;
  bool favori;
  String not;
  DateTime? sonTarih;
  DateTime? hatirlatma;
  final List<Adim> adimlar = [];

  Gorev(
    this.baslik, {
    this.grup = 'Genel',
    this.tamamlandi = false,
    this.favori = false,
    this.not = '',
  });
}

enum EtkinlikTuru { toplanti, onemliGun }

class TakvimEtkinligi {
  final String id;
  String baslik;
  String aciklama;
  EtkinlikTuru tur;
  DateTime tarih;
  TimeOfDay saat;
  bool bildirimAktif;
  int dakikaOnceHatirlat;

  TakvimEtkinligi({
    required this.id,
    required this.baslik,
    this.aciklama = '',
    required this.tur,
    required this.tarih,
    required this.saat,
    this.bildirimAktif = true,
    this.dakikaOnceHatirlat = 15,
  });

  DateTime get tamZaman =>
      DateTime(tarih.year, tarih.month, tarih.day, saat.hour, saat.minute);

  DateTime get bildirimZamani =>
      tamZaman.subtract(Duration(minutes: dakikaOnceHatirlat));
}

class BildirimServisi {
  static Future<void> zamanla(TakvimEtkinligi etkinlik) async {
    debugPrint(
      'Bildirim planlandı: ${etkinlik.baslik} -> ${etkinlik.bildirimZamani}',
    );
  }

  static Future<void> iptalEt(String id) async {
    debugPrint('Bildirim iptal edildi: $id');
  }
}

class Bicim {
  bool kalin;
  bool italik;
  bool altCizgi;
  bool ustCizgi;
  int? renk;
  int? vurgu;
  double boyut;

  Bicim({
    this.kalin = false,
    this.italik = false,
    this.altCizgi = false,
    this.ustCizgi = false,
    this.renk,
    this.vurgu,
    this.boyut = 16,
  });

  Bicim kopya() => Bicim(
        kalin: kalin,
        italik: italik,
        altCizgi: altCizgi,
        ustCizgi: ustCizgi,
        renk: renk,
        vurgu: vurgu,
        boyut: boyut,
      );

  void al(Bicim o) {
    kalin = o.kalin;
    italik = o.italik;
    altCizgi = o.altCizgi;
    ustCizgi = o.ustCizgi;
    renk = o.renk;
    vurgu = o.vurgu;
    boyut = o.boyut;
  }

  bool ayni(Bicim o) =>
      kalin == o.kalin &&
      italik == o.italik &&
      altCizgi == o.altCizgi &&
      ustCizgi == o.ustCizgi &&
      renk == o.renk &&
      vurgu == o.vurgu &&
      boyut == o.boyut;

  TextStyle stil(TextStyle temel) {
    final dekor = <TextDecoration>[
      if (altCizgi) TextDecoration.underline,
      if (ustCizgi) TextDecoration.lineThrough,
    ];
    return temel.copyWith(
      fontWeight: kalin ? FontWeight.bold : FontWeight.normal,
      fontStyle: italik ? FontStyle.italic : FontStyle.normal,
      decoration: dekor.isEmpty
          ? TextDecoration.none
          : TextDecoration.combine(dekor),
      color: renk == null ? null : Color(renk!),
      backgroundColor: vurgu == null ? null : Color(vurgu!),
      fontSize: boyut,
    );
  }
}

class Sayfa {
  String baslik;
  String icerik;
  List<Bicim> bicimler;
  int hiza = 0;

  Sayfa(this.baslik, this.icerik)
      : bicimler = List.generate(icerik.length, (_) => Bicim());
}

class ArsivDosyasi {
  String ad;
  String tur;
  DateTime tarih;

  ArsivDosyasi(this.ad, this.tur, this.tarih);
}

IconData turIkonu(String tur) {
  switch (tur) {
    case 'PDF':
      return Icons.picture_as_pdf;
    case 'Word':
      return Icons.description;
    case 'Excel':
      return Icons.table_chart;
    case 'Resim':
      return Icons.image;
    default:
      return Icons.insert_drive_file;
  }
}

Color turRengi(String tur) {
  switch (tur) {
    case 'PDF':
      return Colors.red;
    case 'Word':
      return Colors.blue;
    case 'Excel':
      return Colors.green;
    case 'Resim':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}

String uzanti(String tur) {
  switch (tur) {
    case 'PDF':
      return '.pdf';
    case 'Word':
      return '.docx';
    case 'Excel':
      return '.xlsx';
    case 'Resim':
      return '.jpg';
    default:
      return '';
  }
}

String ikiHane(int n) => n.toString().padLeft(2, '0');

String tarihYaz(DateTime d) =>
    '${ikiHane(d.day)}.${ikiHane(d.month)}.${d.year}';

String saatYaz(DateTime d) => '${ikiHane(d.hour)}:${ikiHane(d.minute)}';

String todYaz(TimeOfDay t) => '${ikiHane(t.hour)}:${ikiHane(t.minute)}';

bool ayniGunMu(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

const List<String> turkceAylar = [
  'Ocak',
  'Şubat',
  'Mart',
  'Nisan',
  'Mayıs',
  'Haziran',
  'Temmuz',
  'Ağustos',
  'Eylül',
  'Ekim',
  'Kasım',
  'Aralık',
];

const List<String> kisaGunler = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

// ---------- ZENGİN METİN KONTROLCÜSÜ ----------

class ZenginKontrol extends TextEditingController {
  List<Bicim> bicimler;
  Bicim yazimBicimi = Bicim();
  bool _dahili = false;

  static final RegExp _numaraOn = RegExp(r'^\d+\. ');

  ZenginKontrol(String metin, this.bicimler) : super(text: metin) {
    _esitle();
  }

  void _esitle() {
    if (bicimler.length != text.length) {
      bicimler = List.generate(text.length, (_) => Bicim());
    }
  }

  @override
  set value(TextEditingValue yeni) {
    if (!_dahili) {
      final eski = text;
      final yeniMetin = yeni.text;
      if (eski != yeniMetin) {
        _esitle();
        final enAz = eski.length < yeniMetin.length
            ? eski.length
            : yeniMetin.length;
        var p = 0;
        while (p < enAz && eski[p] == yeniMetin[p]) {
          p++;
        }
        var s = 0;
        while (s < enAz - p &&
            eski[eski.length - 1 - s] == yeniMetin[yeniMetin.length - 1 - s]) {
          s++;
        }
        final silinen = eski.length - p - s;
        final eklenen = yeniMetin.length - p - s;
        bicimler.removeRange(p, p + silinen);
        bicimler.insertAll(
          p,
          List.generate(eklenen, (_) => yazimBicimi.kopya()),
        );
      } else if (yeni.selection != selection && yeni.selection.isCollapsed) {
        final konum = yeni.selection.baseOffset;
        if (konum > 0 && konum <= bicimler.length) {
          yazimBicimi = bicimler[konum - 1].kopya();
        } else if (konum == 0) {
          yazimBicimi = bicimler.isEmpty ? Bicim() : bicimler[0].kopya();
        }
      }
    }
    super.value = yeni;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final temel = style ?? const TextStyle();
    if (bicimler.length != text.length) {
      return TextSpan(text: text, style: temel);
    }
    final parcalar = <InlineSpan>[];
    var i = 0;
    while (i < text.length) {
      var j = i + 1;
      while (j < text.length && bicimler[j].ayni(bicimler[i])) {
        j++;
      }
      parcalar.add(
        TextSpan(text: text.substring(i, j), style: bicimler[i].stil(temel)),
      );
      i = j;
    }
    return TextSpan(style: temel, children: parcalar);
  }

  void uygula(void Function(Bicim) degistir) {
    _esitle();
    final sel = selection;
    if (sel.isValid && !sel.isCollapsed) {
      for (var i = sel.start; i < sel.end && i < bicimler.length; i++) {
        degistir(bicimler[i]);
      }
    }
    degistir(yazimBicimi);
    notifyListeners();
  }

  Bicim referans() {
    _esitle();
    final sel = selection;
    if (sel.isValid && !sel.isCollapsed && sel.start < bicimler.length) {
      return bicimler[sel.start];
    }
    return yazimBicimi;
  }

  int satirBasi(int konum) {
    if (konum <= 0) return 0;
    final k = konum > text.length ? text.length : konum;
    final i = text.lastIndexOf('\n', k - 1);
    return i == -1 ? 0 : i + 1;
  }

  int satirSonu(int konum) {
    final i = text.indexOf('\n', konum);
    return i == -1 ? text.length : i;
  }

  String mevcutSatir() {
    var konum = selection.isValid ? selection.start : text.length;
    if (konum > text.length) konum = text.length;
    final bas = satirBasi(konum);
    return text.substring(bas, satirSonu(bas));
  }

  int onUzunlugu(String satir) {
    if (satir.startsWith('• ') ||
        satir.startsWith('☐ ') ||
        satir.startsWith('☑ ') ||
        satir.startsWith('★ ')) {
      return 2;
    }
    final m = _numaraOn.firstMatch(satir);
    return m == null ? 0 : m.group(0)!.length;
  }

  void onEkiAyarla(String yeni, {Bicim? stil}) {
    _esitle();
    var konum = selection.isValid ? selection.start : text.length;
    if (konum > text.length) konum = text.length;
    final bas = satirBasi(konum);
    final son = satirSonu(bas);
    final eskiUz = onUzunlugu(text.substring(bas, son));
    final yeniMetin = text.replaceRange(bas, bas + eskiUz, yeni);
    bicimler.replaceRange(
      bas,
      bas + eskiUz,
      List.generate(yeni.length, (_) => (stil ?? Bicim()).kopya()),
    );
    final fark = yeni.length - eskiUz;
    int kaydir(int o) {
      if (o < bas) return o;
      final y = o + fark;
      return y < bas ? bas : y;
    }

    final sel = selection;
    _dahili = true;
    value = TextEditingValue(
      text: yeniMetin,
      selection: TextSelection(
        baseOffset: kaydir(sel.baseOffset),
        extentOffset: kaydir(sel.extentOffset),
      ),
    );
    _dahili = false;
  }

  void numaraliListe() {
    final satir = mevcutSatir();
    if (_numaraOn.hasMatch(satir)) {
      onEkiAyarla('');
      return;
    }
    var n = 1;
    var konum = selection.isValid ? selection.start : text.length;
    if (konum > text.length) konum = text.length;
    final bas = satirBasi(konum);
    if (bas > 0) {
      final oncekiBas = satirBasi(bas - 1);
      final onceki = text.substring(oncekiBas, bas - 1);
      final m = _numaraOn.firstMatch(onceki);
      if (m != null) {
        n = int.parse(m.group(0)!.replaceAll(RegExp(r'[^0-9]'), '')) + 1;
      }
    }
    onEkiAyarla('$n. ');
  }

  void baslikUygula(double boyut, bool kalin) {
    _esitle();
    final sel = selection;
    final a = sel.isValid ? sel.start : 0;
    final b = sel.isValid ? sel.end : 0;
    final bas = satirBasi(a);
    final son = satirSonu(b);
    for (var i = bas; i < son && i < bicimler.length; i++) {
      bicimler[i].boyut = boyut;
      bicimler[i].kalin = kalin;
    }
    yazimBicimi.boyut = boyut;
    yazimBicimi.kalin = kalin;
    notifyListeners();
  }

  void degistir(int bas, int son, String yeni) {
    final t = text.replaceRange(bas, son, yeni);
    value = TextEditingValue(
      text: t,
      selection: TextSelection.collapsed(offset: bas + yeni.length),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      title: uygulamaAdi,
      debugShowCheckedModeBanner: false,
      theme: temaOlustur(),
      home: const GirisEkrani(),
    ),
  );
}

// ---------- LOGO ----------

class Logo extends StatelessWidget {
  final double boyut;

  const Logo({super.key, this.boyut = 130});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boyut,
      height: boyut,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.black, width: boyut * 0.03),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (rect) => const LinearGradient(
              colors: [Colors.black, Color(0xFF9E9E9E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(rect),
            child: Text(
              'M',
              style: TextStyle(
                fontSize: boyut * 0.5,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1,
              ),
            ),
          ),
          Text(
            'MEMORA',
            style: TextStyle(
              fontSize: boyut * 0.11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- GİRİŞ ----------

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final epostaKontrol = TextEditingController();
  final sifreKontrol = TextEditingController();
  bool sifreGizli = true;
  bool kayitModu = false;
  String? hata;

  @override
  void dispose() {
    epostaKontrol.dispose();
    sifreKontrol.dispose();
    super.dispose();
  }

  void devam() {
    if (epostaKontrol.text.trim().isEmpty || sifreKontrol.text.length < 6) {
      setState(() {
        hata = 'E-posta boş olamaz, şifre en az 6 karakter olmalı.';
      });
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AnaEkran()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [koyuMavi, anaMavi],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Logo(),
                    const SizedBox(height: 16),
                    const Text(
                      'Notların, görevlerin, hepsi bir arada',
                      style: TextStyle(
                        color: Colors.white70,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 30,
                            offset: Offset(0, 14),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kayitModu ? 'Hesap oluştur' : 'Hoş geldin',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            kayitModu
                                ? 'Birkaç saniyede başla.'
                                : 'Devam etmek için giriş yap.',
                            style: const TextStyle(color: Color(0xFF5B6B8C)),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: epostaKontrol,
                            keyboardType: TextInputType.emailAddress,
                            decoration: girdiStili(
                              'E-posta',
                              Icons.email_outlined,
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: sifreKontrol,
                            obscureText: sifreGizli,
                            decoration: girdiStili(
                              'Şifre',
                              Icons.lock_outline,
                              sonek: IconButton(
                                icon: Icon(
                                  sifreGizli
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    sifreGizli = !sifreGizli;
                                  });
                                },
                              ),
                            ),
                          ),
                          if (hata != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              hata!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: FilledButton(
                              onPressed: devam,
                              child: Text(
                                kayitModu ? 'Hesap Oluştur' : 'Giriş Yap',
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  kayitModu = !kayitModu;
                                  hata = null;
                                });
                              },
                              child: Text(
                                kayitModu
                                    ? 'Hesabın var mı? Giriş yap'
                                    : 'Hesabın yok mu? Hesap oluştur',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Sürüm $surum',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------- ANA EKRAN ----------

class AnaEkran extends StatefulWidget {
  const AnaEkran({super.key});

  @override
  State<AnaEkran> createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  final List<String> gruplar = ['Genel', 'İş', 'Kişisel'];
  String? secili;
  final gorevKontrol = TextEditingController();
  String arama = '';

  DateTime gorunenAy = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime seciliGun = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  EtkinlikTuru? takvimFiltre;
  final Set<String> tetiklenenBildirimler = {};
  Timer? _bildirimZamanlayici;

  final List<Gorev> gorevler = [
    Gorev('Süt al', grup: 'Kişisel'),
    Gorev('Rapor hazırla', grup: 'İş')..adimlar.add(Adim('Taslak yaz')),
    Gorev('Spor yap', grup: 'Kişisel'),
  ];

  final List<Sayfa> sayfalar = [
    Sayfa('Taleplere Hazır Cevaplar', 'Merhaba,\nİyi çalışmalar.'),
  ];

  final List<ArsivDosyasi> dosyalar = [
    ArsivDosyasi('Kurulum Rehberi.pdf', 'PDF', DateTime(2026, 11, 20)),
    ArsivDosyasi('Toplantı Notları.docx', 'Word', DateTime(2026, 11, 22)),
  ];

  late final List<TakvimEtkinligi> etkinlikler = [
    TakvimEtkinligi(
      id: '1',
      baslik: 'BT Sistem & Altyapı Toplantısı',
      aciklama: 'Sunucu bakımı ve Exchange güncellemeleri',
      tur: EtkinlikTuru.toplanti,
      tarih: DateTime.now(),
      saat: const TimeOfDay(hour: 14, minute: 30),
      bildirimAktif: true,
      dakikaOnceHatirlat: 15,
    ),
    TakvimEtkinligi(
      id: '2',
      baslik: 'Önemli Gün Hatırlatması',
      aciklama: 'Özel plan ve kutlama',
      tur: EtkinlikTuru.onemliGun,
      tarih: DateTime.now().add(const Duration(days: 2)),
      saat: const TimeOfDay(hour: 10, minute: 0),
      bildirimAktif: true,
      dakikaOnceHatirlat: 60,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bildirimZamanlayici = Timer.periodic(
      const Duration(seconds: 20),
      (_) => yaklasanBildirimleriKontrolEt(),
    );
  }

  @override
  void dispose() {
    _bildirimZamanlayici?.cancel();
    gorevKontrol.dispose();
    super.dispose();
  }

  // ---------- BİLDİRİM YÖNETİMİ ----------

  void bildirimGonder(String baslik, String icerik) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Row(
            children: [
              const Icon(Icons.notifications_active, color: Color(0xFF7FB0FF)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      baslik,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(icerik, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  void yaklasanBildirimleriKontrolEt() {
    final simdi = DateTime.now();
    for (final e in etkinlikler) {
      if (!e.bildirimAktif || tetiklenenBildirimler.contains(e.id)) continue;
      final fark = simdi.difference(e.bildirimZamani).inMinutes;
      if (fark >= 0 && fark <= 5) {
        tetiklenenBildirimler.add(e.id);
        final etiket =
            e.tur == EtkinlikTuru.toplanti ? 'Toplantı' : 'Önemli Gün';
        bildirimGonder(
          '$etiket Hatırlatması: ${e.baslik}',
          '${tarihYaz(e.tarih)} • ${todYaz(e.saat)}',
        );
      }
    }
  }

  // ---------- ORTAK: ONAY PENCERESİ ----------

  Future<bool> onayIste(String baslik, String metin) async {
    final sonuc = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(baslik),
        content: Text(metin),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    return sonuc == true;
  }

  // ---------- GÖREVLER ----------

  void gorevEkle(String metin) {
    final baslik = metin.trim();
    if (baslik.isEmpty) return;
    setState(() {
      gorevler.add(Gorev(baslik, grup: secili ?? gruplar.first));
      gorevKontrol.clear();
    });
  }

  void gorevSil(Gorev g) {
    final sira = gorevler.indexOf(g);
    setState(() {
      gorevler.remove(g);
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('"${g.baslik}" silindi'),
          action: SnackBarAction(
            label: 'Geri Al',
            onPressed: () {
              setState(() {
                gorevler.insert(
                  sira > gorevler.length ? gorevler.length : sira,
                  g,
                );
              });
            },
          ),
        ),
      );
  }

  Future<void> tamamlananlariTemizle(List<Gorev> silinecek) async {
    final tamam = await onayIste(
      'Tamamlananlar temizlensin mi?',
      '${silinecek.length} görev kalıcı olarak silinecek.',
    );
    if (!tamam) return;
    setState(() {
      gorevler.removeWhere((g) => silinecek.contains(g));
    });
  }

  Future<void> grupEkle() async {
    final kontrol = TextEditingController();
    final ad = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yeni grup'),
        content: TextField(
          controller: kontrol,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Grup adı'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, kontrol.text.trim()),
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
    if (ad != null && ad.isNotEmpty && !gruplar.contains(ad)) {
      setState(() {
        gruplar.add(ad);
        secili = ad;
      });
    }
  }

  Future<void> grupSil(String grup) async {
    final adet = gorevler.where((g) => g.grup == grup).length;
    final tamam = await onayIste(
      '"$grup" grubu silinsin mi?',
      adet == 0
          ? 'Grup silinecek.'
          : 'Grup ve içindeki $adet görev kalıcı olarak silinecek.',
    );
    if (!tamam) return;
    setState(() {
      gorevler.removeWhere((g) => g.grup == grup);
      gruplar.remove(grup);
      secili = null;
    });
  }

  Future<void> gorevAc(Gorev g) async {
    final sil = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => GorevDetay(gorev: g, gruplar: gruplar),
      ),
    );
    if (!mounted) return;
    if (sil == true) {
      gorevSil(g);
    } else {
      setState(() {});
    }
  }

  Widget gorevSatiri(Gorev g, {bool silik = false, bool kartli = true}) {
    final bilgi = <String>[];
    if (secili == null) bilgi.add(g.grup);
    if (g.adimlar.isNotEmpty) {
      final biten = g.adimlar.where((a) => a.tamam).length;
      bilgi.add('$biten/${g.adimlar.length} adım');
    }
    if (g.sonTarih != null) bilgi.add(tarihYaz(g.sonTarih!));

    final satir = Dismissible(
      key: ObjectKey(g),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => gorevSil(g),
      child: ListTile(
        leading: Checkbox(
          value: g.tamamlandi,
          onChanged: (yeni) {
            setState(() {
              g.tamamlandi = yeni ?? false;
            });
          },
        ),
        title: Text(
          g.baslik,
          style: silik
              ? const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                )
              : const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: bilgi.isEmpty ? null : Text(bilgi.join(' • ')),
        trailing: IconButton(
          icon: Icon(
            g.favori ? Icons.star_rounded : Icons.star_border_rounded,
            color: g.favori ? Colors.amber : null,
          ),
          onPressed: () {
            setState(() {
              g.favori = !g.favori;
            });
          },
        ),
        onTap: () => gorevAc(g),
      ),
    );

    return kartli ? kartSatir(satir) : satir;
  }

  Widget gorevlerSekmesi() {
    final filtreli = gorevler
        .where((g) => secili == null || g.grup == secili)
        .toList();
    final aktifler = filtreli.where((g) => !g.tamamlandi).toList();
    final sirali = [
      ...aktifler.where((g) => g.favori),
      ...aktifler.where((g) => !g.favori),
    ];
    final bitenler = filtreli.where((g) => g.tamamlandi).toList();

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              grupChip('Tümü', secili == null, () {
                setState(() {
                  secili = null;
                });
              }),
              for (final grup in gruplar) ...[
                const SizedBox(width: 8),
                grupChip(grup, secili == grup, () {
                  setState(() {
                    secili = grup;
                  });
                }),
              ],
              const SizedBox(width: 8),
              ActionChip(
                avatar: const Icon(Icons.add, size: 18, color: anaMavi),
                label: const Text(
                  'Grup',
                  style: TextStyle(color: anaMavi, fontWeight: FontWeight.w600),
                ),
                backgroundColor: acikMavi,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: grupEkle,
              ),
              if (secili != null && gruplar.length > 1) ...[
                const SizedBox(width: 8),
                ActionChip(
                  avatar: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Grubu sil',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: const Color(0xFFFFEEEE),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () => grupSil(secili!),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: sirali.isEmpty
              ? bosDurum(Icons.check_circle_outline, 'Bekleyen görev yok')
              : ListView(children: [for (final g in sirali) gorevSatiri(g)]),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 220),
          child: SingleChildScrollView(
            child: kartSatir(
              ExpansionTile(
                shape: const RoundedRectangleBorder(),
                collapsedShape: const RoundedRectangleBorder(),
                iconColor: anaMavi,
                collapsedIconColor: anaMavi,
                leading: const Icon(Icons.inventory_2_outlined, color: anaMavi),
                title: Text(
                  'Tamamlananlar (${bitenler.length})',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                initiallyExpanded: true,
                children: [
                  if (bitenler.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: const Icon(Icons.delete_sweep_outlined),
                        label: const Text('Tamamlananları temizle'),
                        onPressed: () => tamamlananlariTemizle(bitenler),
                      ),
                    ),
                  for (final g in bitenler)
                    gorevSatiri(g, silik: true, kartli: false),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
          margin: const EdgeInsets.only(top: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: cizgiRenk)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: gorevKontrol,
                    decoration: InputDecoration(
                      hintText: 'Görev ekle (${secili ?? gruplar.first})',
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.add_circle_outline,
                        color: anaMavi,
                      ),
                    ),
                    onSubmitted: gorevEkle,
                  ),
                ),
                IconButton.filled(
                  icon: const Icon(Icons.arrow_upward_rounded),
                  onPressed: () => gorevEkle(gorevKontrol.text),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------- NOT DEFTERİ ----------

  Future<void> sayfaAc(Sayfa s) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SayfaEkrani(sayfa: s)),
    );
    if (!mounted) return;
    setState(() {});
  }

  Widget notDefteriSekmesi() {
    return Scaffold(
      body: sayfalar.isEmpty
          ? bosDurum(Icons.edit_note, 'Henüz sayfa yok. + ile ekle.')
          : ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              children: [
                for (final s in sayfalar)
                  kartSatir(
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: acikMavi,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          color: anaMavi,
                        ),
                      ),
                      title: Text(
                        s.baslik.isEmpty ? 'Başlıksız sayfa' : s.baslik,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        s.icerik,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          final tamam = await onayIste(
                            'Sayfa silinsin mi?',
                            '"${s.baslik.isEmpty ? 'Başlıksız sayfa' : s.baslik}" kalıcı olarak silinecek.',
                          );
                          if (tamam) {
                            setState(() {
                              sayfalar.remove(s);
                            });
                          }
                        },
                      ),
                      onTap: () => sayfaAc(s),
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final yeni = Sayfa('', '');
          setState(() {
            sayfalar.add(yeni);
          });
          sayfaAc(yeni);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // ---------- TAKVİM ----------

  Future<void> etkinlikEkleDialog() async {
    final baslikKontrol = TextEditingController();
    final aciklamaKontrol = TextEditingController();
    EtkinlikTuru tur = EtkinlikTuru.toplanti;
    DateTime tarih = seciliGun;
    TimeOfDay saat = const TimeOfDay(hour: 10, minute: 0);
    bool bildirim = true;
    int onceDk = 15;

    final yeni = await showDialog<TakvimEtkinligi>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          title: const Text('Takvime Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SegmentedButton<EtkinlikTuru>(
                  segments: const [
                    ButtonSegment(
                      value: EtkinlikTuru.toplanti,
                      label: Text('Toplantı'),
                      icon: Icon(Icons.groups_outlined),
                    ),
                    ButtonSegment(
                      value: EtkinlikTuru.onemliGun,
                      label: Text('Önemli Gün'),
                      icon: Icon(Icons.star_outline_rounded),
                    ),
                  ],
                  selected: {tur},
                  onSelectionChanged: (s) {
                    setModal(() => tur = s.first);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: baslikKontrol,
                  autofocus: true,
                  decoration: girdiStili('Başlık', Icons.title),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: aciklamaKontrol,
                  decoration: girdiStili('Açıklama / Konum', Icons.notes),
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today, color: anaMavi),
                  title: Text('Tarih: ${tarihYaz(tarih)}'),
                  onTap: () async {
                    final sec = await showDatePicker(
                      context: ctx,
                      initialDate: tarih,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (sec != null) setModal(() => tarih = sec);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.access_time, color: anaMavi),
                  title: Text('Saat: ${todYaz(saat)}'),
                  onTap: () async {
                    final sec = await showTimePicker(
                      context: ctx,
                      initialTime: saat,
                    );
                    if (sec != null) setModal(() => saat = sec);
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Bildirim gönder'),
                  value: bildirim,
                  activeColor: anaMavi,
                  onChanged: (v) => setModal(() => bildirim = v),
                ),
                if (bildirim)
                  DropdownButtonFormField<int>(
                    value: onceDk,
                    decoration: girdiStili('Hatırlatma zamanı', Icons.alarm),
                    items: const [
                      DropdownMenuItem(value: 0, child: Text('Tam zamanında')),
                      DropdownMenuItem(value: 5, child: Text('5 dk önce')),
                      DropdownMenuItem(value: 15, child: Text('15 dk önce')),
                      DropdownMenuItem(value: 30, child: Text('30 dk önce')),
                      DropdownMenuItem(value: 60, child: Text('1 saat önce')),
                      DropdownMenuItem(value: 1440, child: Text('1 gün önce')),
                    ],
                    onChanged: (v) {
                      if (v != null) setModal(() => onceDk = v);
                    },
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () {
                final b = baslikKontrol.text.trim();
                if (b.isEmpty) return;
                Navigator.pop(
                  ctx,
                  TakvimEtkinligi(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    baslik: b,
                    aciklama: aciklamaKontrol.text.trim(),
                    tur: tur,
                    tarih: tarih,
                    saat: saat,
                    bildirimAktif: bildirim,
                    dakikaOnceHatirlat: onceDk,
                  ),
                );
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );

    if (yeni == null || !mounted) return;
    setState(() {
      etkinlikler.add(yeni);
      seciliGun = DateTime(yeni.tarih.year, yeni.tarih.month, yeni.tarih.day);
      gorunenAy = DateTime(yeni.tarih.year, yeni.tarih.month, 1);
    });

    if (yeni.bildirimAktif) {
      await BildirimServisi.zamanla(yeni);
      final turEtiket =
          yeni.tur == EtkinlikTuru.toplanti ? 'Toplantı' : 'Önemli Gün';
      bildirimGonder(
        '$turEtiket bildirimi kuruldu',
        '${yeni.baslik} • ${tarihYaz(yeni.tarih)} ${todYaz(yeni.saat)}',
      );
    }
  }

  List<DateTime?> ayGunleriniOlustur(DateTime ay) {
    final ilkGun = DateTime(ay.year, ay.month, 1);
    final sonGun = DateTime(ay.year, ay.month + 1, 0);
    final bosBaslangic = ilkGun.weekday - 1;
    final hucreler = <DateTime?>[
      for (var i = 0; i < bosBaslangic; i++) null,
      for (var d = 1; d <= sonGun.day; d++) DateTime(ay.year, ay.month, d),
    ];
    while (hucreler.length % 7 != 0) {
      hucreler.add(null);
    }
    return hucreler;
  }

  Widget takvimSekmesi() {
    final bugun = DateTime.now();
    final hucreler = ayGunleriniOlustur(gorunenAy);

    final gunEtkinlikleri = etkinlikler.where((e) {
      final gunEslesme = ayniGunMu(e.tarih, seciliGun);
      final turEslesme = takvimFiltre == null || e.tur == takvimFiltre;
      return gunEslesme && turEslesme;
    }).toList()
      ..sort((a, b) => a.tamZaman.compareTo(b.tamZaman));

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(bottom: 84),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: Row(
              children: [
                grupChip('Tümü', takvimFiltre == null, () {
                  setState(() => takvimFiltre = null);
                }),
                const SizedBox(width: 8),
                grupChip(
                  'Toplantılar',
                  takvimFiltre == EtkinlikTuru.toplanti,
                  () {
                    setState(() => takvimFiltre = EtkinlikTuru.toplanti);
                  },
                ),
                const SizedBox(width: 8),
                grupChip(
                  'Önemli Günler',
                  takvimFiltre == EtkinlikTuru.onemliGun,
                  () {
                    setState(() => takvimFiltre = EtkinlikTuru.onemliGun);
                  },
                ),
                const SizedBox(width: 8),
                ActionChip(
                  avatar: const Icon(Icons.today, size: 18, color: anaMavi),
                  label: const Text(
                    'Bugün',
                    style: TextStyle(color: anaMavi, fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: acikMavi,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    setState(() {
                      seciliGun = DateTime(bugun.year, bugun.month, bugun.day);
                      gorunenAy = DateTime(bugun.year, bugun.month, 1);
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            child: kart(
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {
                            setState(() {
                              gorunenAy = DateTime(
                                gorunenAy.year,
                                gorunenAy.month - 1,
                                1,
                              );
                            });
                          },
                        ),
                        Text(
                          '${turkceAylar[gorunenAy.month - 1]} ${gorunenAy.year}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: koyuMavi,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            setState(() {
                              gorunenAy = DateTime(
                                gorunenAy.year,
                                gorunenAy.month + 1,
                                1,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        for (final g in kisaGunler)
                          Expanded(
                            child: Center(
                              child: Text(
                                g,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF5B6B8C),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: hucreler.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        childAspectRatio: 1.15,
                      ),
                      itemBuilder: (_, idx) {
                        final gun = hucreler[idx];
                        if (gun == null) return const SizedBox.shrink();

                        final seciliMi = ayniGunMu(gun, seciliGun);
                        final bugunMu = ayniGunMu(gun, bugun);
                        final gunKayitlari = etkinlikler
                            .where((e) => ayniGunMu(e.tarih, gun))
                            .toList();
                        final toplantiVar = gunKayitlari
                            .any((e) => e.tur == EtkinlikTuru.toplanti);
                        final onemliVar = gunKayitlari
                            .any((e) => e.tur == EtkinlikTuru.onemliGun);

                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            setState(() => seciliGun = gun);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: seciliMi
                                  ? anaMavi
                                  : (bugunMu ? acikMavi : Colors.transparent),
                              borderRadius: BorderRadius.circular(10),
                              border: bugunMu && !seciliMi
                                  ? Border.all(color: anaMavi)
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${gun.day}',
                                  style: TextStyle(
                                    fontWeight: seciliMi || bugunMu
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    color: seciliMi ? Colors.white : koyuMavi,
                                  ),
                                ),
                                if (toplantiVar || onemliVar)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (toplantiVar)
                                          Container(
                                            width: 5,
                                            height: 5,
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 1,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: seciliMi
                                                  ? Colors.white
                                                  : anaMavi,
                                            ),
                                          ),
                                        if (onemliVar)
                                          Container(
                                            width: 5,
                                            height: 5,
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 1,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: seciliMi
                                                  ? Colors.amberAccent
                                                  : Colors.orange,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${tarihYaz(seciliGun)} Etkinlikleri (${gunEtkinlikleri.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: koyuMavi,
                  ),
                ),
                const Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: anaMavi),
                    SizedBox(width: 4),
                    Text('Toplantı', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 10),
                    Icon(Icons.circle, size: 8, color: Colors.orange),
                    SizedBox(width: 4),
                    Text('Önemli Gün', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          gunEtkinlikleri.isEmpty
              ? SizedBox(
                  height: 180,
                  child: bosDurum(
                    Icons.event_note,
                    'Bu tarihte plan yok. + ile toplantı veya önemli gün ekle.',
                  ),
                )
              : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: gunEtkinlikleri.length,
                    itemBuilder: (_, idx) {
                      final e = gunEtkinlikleri[idx];
                      final toplantiMi = e.tur == EtkinlikTuru.toplanti;
                      final vurgu = toplantiMi ? anaMavi : Colors.orange;

                      return kartSatir(
                        ListTile(
                          leading: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: vurgu.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              toplantiMi
                                  ? Icons.groups_rounded
                                  : Icons.star_rounded,
                              color: vurgu,
                            ),
                          ),
                          title: Text(
                            e.baslik,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${toplantiMi ? 'Toplantı' : 'Önemli Gün'} • Saat: ${todYaz(e.saat)}',
                              ),
                              if (e.aciklama.isNotEmpty) Text(e.aciklama),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: e.bildirimAktif
                                    ? 'Bildirim açık'
                                    : 'Bildirim kapalı',
                                icon: Icon(
                                  e.bildirimAktif
                                      ? Icons.notifications_active
                                      : Icons.notifications_off_outlined,
                                  color: e.bildirimAktif ? anaMavi : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    e.bildirimAktif = !e.bildirimAktif;
                                  });
                                  if (e.bildirimAktif) {
                                    bildirimGonder(
                                      'Hatırlatma Açık: ${e.baslik}',
                                      '${tarihYaz(e.tarih)} • ${todYaz(e.saat)}',
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () async {
                                  final onay = await onayIste(
                                    'Etkinlik silinsin mi?',
                                    '"${e.baslik}" takvimden silinecek.',
                                  );
                                  if (onay) {
                                    await BildirimServisi.iptalEt(e.id);
                                    setState(() {
                                      etkinlikler.remove(e);
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: etkinlikEkleDialog,
        icon: const Icon(Icons.add),
        label: const Text('Etkinlik Ekle'),
      ),
    );
  }

  // ---------- ARŞİV ----------

  Future<void> dosyaEkle() async {
    final tur = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Dosya türü seç',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
            for (final t in ['PDF', 'Word', 'Excel', 'Resim', 'Diğer'])
              ListTile(
                leading: Icon(turIkonu(t), color: turRengi(t)),
                title: Text(t),
                onTap: () => Navigator.pop(ctx, t),
              ),
          ],
        ),
      ),
    );
    if (tur == null || !mounted) return;

    final kontrol = TextEditingController();
    final ad = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Dosya adı'),
        content: TextField(
          controller: kontrol,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Örn. Sözleşme'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, kontrol.text.trim()),
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
    if (ad == null || ad.isEmpty) return;

    setState(() {
      dosyalar.add(ArsivDosyasi('$ad${uzanti(tur)}', tur, DateTime.now()));
    });
  }

  Widget arsivSekmesi() {
    final liste = dosyalar
        .where((d) => d.ad.toLowerCase().contains(arama.toLowerCase()))
        .toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              decoration: girdiStili('Arşivde ara', Icons.search),
              onChanged: (v) {
                setState(() {
                  arama = v;
                });
              },
            ),
          ),
          Expanded(
            child: liste.isEmpty
                ? bosDurum(Icons.folder_open, 'Arşivde dosya yok. + ile ekle.')
                : ListView(
                    padding: const EdgeInsets.only(bottom: 80),
                    children: [
                      for (final d in liste)
                        kartSatir(
                          ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: turRengi(d.tur).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                turIkonu(d.tur),
                                color: turRengi(d.tur),
                              ),
                            ),
                            title: Text(
                              d.ad,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text('Eklendi: ${tarihYaz(d.tarih)}'),
                            trailing: PopupMenuButton<String>(
                              onSelected: (_) async {
                                final tamam = await onayIste(
                                  'Dosya silinsin mi?',
                                  '"${d.ad}" arşivden kalıcı olarak silinecek.',
                                );
                                if (tamam) {
                                  setState(() {
                                    dosyalar.remove(d);
                                  });
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(value: 'sil', child: Text('Sil')),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: dosyaEkle,
        child: const Icon(Icons.add),
      ),
    );
  }

  // ---------- ANA İSKELET ----------

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(uygulamaAdi),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [koyuMavi, Color(0xFF1B3F94)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Çıkış',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const GirisEkrani()),
                );
              },
            ),
          ],
          bottom: const TabBar(
            isScrollable: false,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Color(0xFF7FB0FF),
            indicatorWeight: 3,
            dividerColor: Colors.transparent,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 0.2,
            ),
            tabs: [
              Tab(text: 'Görevler'),
              Tab(text: 'Not Defteri'),
              Tab(text: 'Takvim'),
              Tab(text: 'Arşiv'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            gorevlerSekmesi(),
            notDefteriSekmesi(),
            takvimSekmesi(),
            arsivSekmesi(),
          ],
        ),
      ),
    );
  }
}

// ---------- GÖREV DETAY ----------

class GorevDetay extends StatefulWidget {
  final Gorev gorev;
  final List<String> gruplar;

  const GorevDetay({super.key, required this.gorev, required this.gruplar});

  @override
  State<GorevDetay> createState() => _GorevDetayState();
}

class _GorevDetayState extends State<GorevDetay> {
  final adimKontrol = TextEditingController();

  Gorev get g => widget.gorev;

  @override
  void dispose() {
    adimKontrol.dispose();
    super.dispose();
  }

  void adimEkle(String metin) {
    final baslik = metin.trim();
    if (baslik.isEmpty) return;
    setState(() {
      g.adimlar.add(Adim(baslik));
      adimKontrol.clear();
    });
  }

  Future<void> sonTarihSec() async {
    final secilen = await showDatePicker(
      context: context,
      initialDate: g.sonTarih ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (secilen != null) {
      setState(() {
        g.sonTarih = secilen;
      });
    }
  }

  Future<void> hatirlatmaSec() async {
    final tarih = await showDatePicker(
      context: context,
      initialDate: g.hatirlatma ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (tarih == null || !mounted) return;
    final saat = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (saat == null) return;
    setState(() {
      g.hatirlatma = DateTime(
        tarih.year,
        tarih.month,
        tarih.day,
        saat.hour,
        saat.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Görevi sil',
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          kart(
            Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: g.tamamlandi,
                      onChanged: (v) {
                        setState(() {
                          g.tamamlandi = v ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: g.baslik,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          decoration: g.tamamlandi
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (v) => g.baslik = v,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        g.favori
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: g.favori ? Colors.amber : null,
                      ),
                      onPressed: () {
                        setState(() {
                          g.favori = !g.favori;
                        });
                      },
                    ),
                  ],
                ),
                for (final a in g.adimlar)
                  Row(
                    children: [
                      Checkbox(
                        value: a.tamam,
                        onChanged: (v) {
                          setState(() {
                            a.tamam = v ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          a.baslik,
                          style: TextStyle(
                            decoration: a.tamam
                                ? TextDecoration.lineThrough
                                : null,
                            color: a.tamam ? Colors.grey : null,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          setState(() {
                            g.adimlar.remove(a);
                          });
                        },
                      ),
                    ],
                  ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.add, color: anaMavi),
                    ),
                    Expanded(
                      child: TextField(
                        controller: adimKontrol,
                        decoration: const InputDecoration(
                          hintText: 'Sonraki adım',
                          border: InputBorder.none,
                        ),
                        onSubmitted: adimEkle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          kart(
            Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.notifications_outlined,
                    color: anaMavi,
                  ),
                  title: Text(
                    g.hatirlatma == null
                        ? 'Anımsat beni'
                        : 'Anımsatma zamanı: ${saatYaz(g.hatirlatma!)}',
                  ),
                  subtitle: g.hatirlatma == null
                      ? null
                      : Text(tarihYaz(g.hatirlatma!)),
                  trailing: g.hatirlatma == null
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              g.hatirlatma = null;
                            });
                          },
                        ),
                  onTap: hatirlatmaSec,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.event_outlined, color: anaMavi),
                  title: Text(
                    g.sonTarih == null
                        ? 'Son tarih ekle'
                        : 'Son tarih: ${tarihYaz(g.sonTarih!)}',
                  ),
                  trailing: g.sonTarih == null
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              g.sonTarih = null;
                            });
                          },
                        ),
                  onTap: sonTarihSec,
                ),
              ],
            ),
          ),
          kart(
            ListTile(
              leading: const Icon(Icons.folder_outlined, color: anaMavi),
              title: const Text('Grup'),
              trailing: DropdownButton<String>(
                value: g.grup,
                underline: const SizedBox(),
                items: [
                  for (final grup in widget.gruplar)
                    DropdownMenuItem(value: grup, child: Text(grup)),
                ],
                onChanged: (yeni) {
                  if (yeni == null) return;
                  setState(() {
                    g.grup = yeni;
                  });
                },
              ),
            ),
          ),
          kart(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                initialValue: g.not,
                maxLines: 5,
                minLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Not ekle',
                  border: InputBorder.none,
                ),
                onChanged: (v) => g.not = v,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- SAYFA (NOT) EKRANI: ZENGİN METİN EDİTÖRÜ ----------

Widget aracDugme(
  IconData ikon,
  String ipucu,
  VoidCallback tikla, {
  bool aktif = false,
  Color? renk,
}) {
  return Center(
    child: IconButton(
      tooltip: ipucu,
      visualDensity: VisualDensity.compact,
      icon: Icon(ikon, size: 22, color: renk ?? (aktif ? anaMavi : koyuMavi)),
      style: IconButton.styleFrom(
        backgroundColor: aktif ? acikMavi : Colors.transparent,
      ),
      onPressed: tikla,
    ),
  );
}

Widget aracAyirici() {
  return const VerticalDivider(width: 16, indent: 12, endIndent: 12);
}

Widget renkMenusu({
  required IconData ikon,
  required String ipucu,
  required Map<String, int> renkler,
  required Color? gosterge,
  required void Function(int?) sec,
}) {
  return Center(
    child: PopupMenuButton<int>(
      tooltip: ipucu,
      icon: Icon(ikon, size: 22, color: gosterge ?? koyuMavi),
      onSelected: (v) => sec(v == 0 ? null : v),
      itemBuilder: (_) => [
        const PopupMenuItem<int>(value: 0, child: Text('Yok / Varsayılan')),
        for (final e in renkler.entries)
          PopupMenuItem<int>(
            value: e.value,
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Color(e.value),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(e.key),
              ],
            ),
          ),
      ],
    ),
  );
}

class SayfaEkrani extends StatefulWidget {
  final Sayfa sayfa;

  const SayfaEkrani({super.key, required this.sayfa});

  @override
  State<SayfaEkrani> createState() => _SayfaEkraniState();
}

class _SayfaEkraniState extends State<SayfaEkrani> {
  late final ZenginKontrol kontrol;
  final ScrollController aracKaydirma = ScrollController();
  Bicim? boyaci;

  Sayfa get sayfa => widget.sayfa;

  @override
  void initState() {
    super.initState();
    kontrol = ZenginKontrol(sayfa.icerik, sayfa.bicimler);
    kontrol.addListener(() {
      sayfa.icerik = kontrol.text;
      sayfa.bicimler = kontrol.bicimler;
    });
  }

  @override
  void dispose() {
    kontrol.dispose();
    aracKaydirma.dispose();
    super.dispose();
  }

  void acKapa(bool Function(Bicim) oku, void Function(Bicim, bool) yaz) {
    final hedef = !oku(kontrol.referans());
    kontrol.uygula((b) => yaz(b, hedef));
  }

  Future<void> kopyala({bool kes = false}) async {
    final sel = kontrol.selection;
    if (!sel.isValid || sel.isCollapsed) return;
    await Clipboard.setData(
      ClipboardData(text: kontrol.text.substring(sel.start, sel.end)),
    );
    if (kes) {
      kontrol.degistir(sel.start, sel.end, '');
    }
  }

  Future<void> yapistir() async {
    final veri = await Clipboard.getData('text/plain');
    final metin = veri?.text;
    if (metin == null || metin.isEmpty) return;
    final sel = kontrol.selection;
    final bas = sel.isValid ? sel.start : kontrol.text.length;
    final son = sel.isValid ? sel.end : kontrol.text.length;
    kontrol.degistir(bas, son, metin);
  }

  void boyaciKullan() {
    setState(() {
      if (boyaci == null) {
        boyaci = kontrol.referans().kopya();
      } else {
        final b = boyaci!;
        kontrol.uygula((x) => x.al(b));
        boyaci = null;
      }
    });
  }

  void todoDegistir() {
    final satir = kontrol.mevcutSatir();
    if (satir.startsWith('☐ ')) {
      kontrol.onEkiAyarla('☑ ');
    } else if (satir.startsWith('☑ ')) {
      kontrol.onEkiAyarla('');
    } else {
      kontrol.onEkiAyarla('☐ ');
    }
  }

  Widget aracCubugu() {
    final ref = kontrol.referans();
    final satir = kontrol.mevcutSatir();

    return ScrollConfiguration(
      behavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      child: Scrollbar(
        controller: aracKaydirma,
        thumbVisibility: true,
        thickness: 3,
        radius: const Radius.circular(8),
        child: SizedBox(
          height: 52,
          child: ListView(
            controller: aracKaydirma,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              aracDugme(Icons.content_cut, 'Kes', () => kopyala(kes: true)),
              aracDugme(Icons.content_copy, 'Kopyala', () => kopyala()),
              aracDugme(Icons.content_paste, 'Yapıştır', yapistir),
              aracDugme(
                Icons.format_paint,
                'Biçim boyacısı',
                boyaciKullan,
                aktif: boyaci != null,
              ),
              aracAyirici(),
              Center(
                child: PopupMenuButton<double>(
                  tooltip: 'Yazı boyutu',
                  onSelected: (v) => kontrol.uygula((b) => b.boyut = v),
                  itemBuilder: (_) => [
                    for (final s in [12.0, 14.0, 16.0, 18.0, 20.0, 24.0, 28.0])
                      PopupMenuItem<double>(
                        value: s,
                        child: Text('${s.toInt()}'),
                      ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: cizgiRenk),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${ref.boyut.toInt()}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const Icon(Icons.arrow_drop_down, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              aracDugme(
                Icons.format_bold,
                'Kalın',
                () => acKapa((b) => b.kalin, (b, v) => b.kalin = v),
                aktif: ref.kalin,
              ),
              aracDugme(
                Icons.format_italic,
                'İtalik',
                () => acKapa((b) => b.italik, (b, v) => b.italik = v),
                aktif: ref.italik,
              ),
              aracDugme(
                Icons.format_underlined,
                'Altı çizili',
                () => acKapa((b) => b.altCizgi, (b, v) => b.altCizgi = v),
                aktif: ref.altCizgi,
              ),
              aracDugme(
                Icons.format_strikethrough,
                'Üstü çizili',
                () => acKapa((b) => b.ustCizgi, (b, v) => b.ustCizgi = v),
                aktif: ref.ustCizgi,
              ),
              renkMenusu(
                ikon: Icons.border_color,
                ipucu: 'Vurgu rengi',
                renkler: vurguRenkleri,
                gosterge: ref.vurgu == null ? null : Color(ref.vurgu!),
                sec: (v) => kontrol.uygula((b) => b.vurgu = v),
              ),
              renkMenusu(
                ikon: Icons.format_color_text,
                ipucu: 'Yazı rengi',
                renkler: yaziRenkleri,
                gosterge: ref.renk == null ? null : Color(ref.renk!),
                sec: (v) => kontrol.uygula((b) => b.renk = v),
              ),
              aracDugme(
                [
                  Icons.format_align_left,
                  Icons.format_align_center,
                  Icons.format_align_right,
                ][sayfa.hiza],
                'Hizalama',
                () {
                  setState(() {
                    sayfa.hiza = (sayfa.hiza + 1) % 3;
                  });
                },
              ),
              aracDugme(
                Icons.format_clear,
                'Biçimi temizle',
                () => kontrol.uygula((b) => b.al(Bicim())),
              ),
              aracAyirici(),
              Center(
                child: PopupMenuButton<String>(
                  tooltip: 'Stiller',
                  icon: const Icon(Icons.title, size: 22, color: koyuMavi),
                  onSelected: (v) {
                    if (v == 'h1') kontrol.baslikUygula(28, true);
                    if (v == 'h2') kontrol.baslikUygula(22, true);
                    if (v == 'normal') kontrol.baslikUygula(16, false);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'normal', child: Text('Normal')),
                    PopupMenuItem(
                      value: 'h1',
                      child: Text(
                        'Başlık 1',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'h2',
                      child: Text(
                        'Başlık 2',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              aracAyirici(),
              aracDugme(Icons.format_list_bulleted, 'Madde işaretli liste', () {
                if (kontrol.mevcutSatir().startsWith('• ')) {
                  kontrol.onEkiAyarla('');
                } else {
                  kontrol.onEkiAyarla('• ');
                }
              }, aktif: satir.startsWith('• ')),
              aracDugme(
                Icons.format_list_numbered,
                'Numaralı liste',
                kontrol.numaraliListe,
                aktif: RegExp(r'^\d+\. ').hasMatch(satir),
              ),
              aracDugme(
                Icons.check_box_outlined,
                'To Do (onay kutusu)',
                todoDegistir,
                aktif: satir.startsWith('☐ ') || satir.startsWith('☑ '),
              ),
              aracDugme(
                Icons.star_rounded,
                'Önemli',
                () {
                  if (kontrol.mevcutSatir().startsWith('★ ')) {
                    kontrol.onEkiAyarla('');
                  } else {
                    kontrol.onEkiAyarla('★ ', stil: Bicim(renk: 0xFFF59E0B));
                  }
                },
                aktif: satir.startsWith('★ '),
                renk: Colors.amber,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SAYFA')),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: cizgiRenk)),
            ),
            child: ExcludeFocus(
              child: AnimatedBuilder(
                animation: kontrol,
                builder: (context, _) => aracCubugu(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: sayfa.baslik,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Başlık',
                      border: InputBorder.none,
                    ),
                    onChanged: (v) => sayfa.baslik = v,
                  ),
                  const Divider(),
                  Expanded(
                    child: TextField(
                      controller: kontrol,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      textAlign: hizalar[sayfa.hiza],
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: koyuMavi,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Notunu yaz...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}