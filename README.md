# Framed V2 - Premium Movie Discovery Aplikacija

![Logo]([screenshot])

**Framed V2** je moderna Flutter aplikacija dizajnirana za ljubitelje kinematografije koji traže vizuelno impresivno i fluidno iskustvo istraživanja filmova. Fokusirana na "Glassmorphism" estetiku, aplikacija pruža premium osjećaj pri svakoj interakciji.

## 🚀 Ključne Karakteristike

- **Cinematic Home Screen**: Dinamički prikaz trenutno popularnih i najbolje ocijenjenih filmova.
- **Napredno Pretraživanje**: Brza pretraga filmova uz napredno filtriranje po žanrovima.
- **Detalji o Filmu**: Sveobuhvatne informacije uključujući sinopsis, glumačku ekipu (Cast), ključne članove produkcije (Crew) i rejtinge.
- **AI Rezime**: Kratki, inteligentni sažeci filmova generisani za brzo informisanje.
- **Stabilna Reprodukcija Trejlera**: Integrisan YouTube player koji koristi zvanični IFrame API za stabilno gledanje bez prekida.
- **Personalizovana Lista Favorita**: Sačuvajte svoje omiljene filmove u lokalnu bazu podataka za kasniji pregled, dostupnu čak i bez interneta.
- **Robusni Offline Režim**: Pametno rukovanje statusom konekcije uz intuitivne ekrane za greške i ponovni pokušaj.

## 📸 Izgled Aplikacije (Screenshots)

| Home Screen | Detalji Filma | Pretraga |
| :---: | :---: | :---: |
| ![Home]([screenshot]) | ![Details]([screenshot]) | ![Search]([screenshot]) |

| Favoriti | Video Player | Offline Stanje |
| :---: | :---: | :---: |
| ![Favorites]([screenshot]) | ![Player]([screenshot]) | ![Offline]([screenshot]) |

## 🛠 Tehnologije

- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **State Management**: [Riverpod](https://riverpod.dev)
- **Baza Podataka**: [Hive](https://pub.dev/packages/hive) (Brza lokalna NoSQL baza)
- **API**: [TMDB API](https://www.themoviedb.org/documentation/api)
- **Video**: [youtube_player_flutter](https://pub.dev/packages/youtube_player_flutter) (YouTube IFrame API)
- **Dizajn**: Custom Glassmorphism sistem (GlassKit) sa fluidnim animacijama.

## ⚙️ Kako aplikacija radi

Aplikacija prati modernu MVVM (Model-View-ViewModel) arhitekturu:
1.  **Data Layer**: Komunicira sa TMDB API-jem preko `Dio` klijenta i upravlja lokalnim podacima preko `Hive`.
2.  **Logic Layer (ViewModels)**: Obrađuje podatke, filtrira rezultate (npr. pretraga, sortiranje, favoriti) i upravlja stanjem aplikacije putem Riverpod providera.
3.  **UI Layer**: Renderuje komponente koristeći custom "Glass" teme. Svi ekrani su optimizovani da "blede" ispod statusne trake radi bioskopskog efekta.

## 🏁 Početak rada

### Preduslovi
- Instaliran **Flutter SDK** (preporučena verzija 3.24 ili novija)
- Instaliran **Dart SDK**
- Android Studio / VS Code sa Flutter ekstenzijom

### Instalacija

1.  **Klonirajte repozitorijum:**
    ```bash
    git clone https://github.com/korisnik/framed-v2.git
    cd framed_v2
    ```

2.  **Preuzmite zavisnosti:**
    ```bash
    flutter pub get
    ```

3.  **Podešavanje API ključa:**
    Kreirajte `.env` datoteku u korijenu projekta i dodajte svoj TMDB API ključ:
    ```env
    TMDB_API_KEY=vash_api_kljuch_ovde
    ```

4.  **Pokretanje aplikacije:**
    ```bash
    flutter run
    ```

## 📝 Napomena o dizajnu
Aplikacija koristi standardizovane layout-e sa vertikalnim offsetom od **40px** za sve headere, osiguravajući vizuelnu konzistentnost kroz cijeli korisnički put. Ikone su optimizovane sa dodatnim paddingom kako bi se izbjegao OS "zoom" efekat na različitim uređajima.

---
*Dokumentacija ažurirana: 28.01.2026.*
