# VirtualGardens_RS2
Seminarski rad iz predmeta Razvoj softvera 2 na Fakultetu informacijskih tehnologija u Mostaru

# Upute za pokretanje
- **Otvoriti VirtualGardens_RS2 repozitorij**
- **Otvoriti folder VirtualGardens unutar pomenutog repozitorija**
- **Locirati fit-build-2025-2-12 - env.rar arhivu**
- **Iz te arhive uraditi extract .env file-a u istom folderu (VirtualGardens_RS2/VirtualGardens)**
- **.env file treba biti u VirtualGardens_RS2\VirtualGardens folderu**
- **Unutar VirtualGardens_RS2\VirtualGardens, otvoriti terminal i pokrenuti komandu docker compose up --build, te sačekati da se sve uspješno build-a.**
- **Vratiti se u VirtualGardens_RS2 folder i locirati fit-build-2025-02-12.part1.rar arhivu**
- **Iz te arhive uraditi extract, gdje biste trebali dobiti dva foldera: Debug i flutter-apk.**
- **Otvoriti Debug folder i iz njega otvoriti virtualgardens_admin.exe**
- **Otvoriti flutter-apk folder**
- **File app-debug.apk prenijeti na emulator i sačekati da se instalira. (Deinstalirati aplikaciju sa emulatora ukoliko je prije bila instalirana!)**
- **Nakon instaliranja obe aplikacije, na iste se možete prijaviti koristeći kredencijale ispod.**

## Kredencijali za prijavu

### Administrator (desktop aplikacija):
- **Korisničko ime:** `desktop`
- **Lozinka:** `test`

### Kupac (mobilna aplikacija):
- **Korisničko ime:** `mobile`
- **Lozinka:** `test`

## PayPal Kredencijali
- **Email:** `sb-htqpr36791194@personal.example.com`
- **Lozinka:** `*cSa>6Vo`
- **Plaćanje je omogućeno na ekranu gdje su prikazani detalji narudžbe**

## Mikroservis
- **Rabbitmq je iskorišten za slanje mailova nakon što administrator promijeni stanje neke ponude u "Aktivna"** 
  
