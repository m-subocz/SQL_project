-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 20 Gru 2020, 12:51
-- Wersja serwera: 10.4.14-MariaDB
-- Wersja PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `rozlewnia`
--

DELIMITER $$
--
-- Procedury
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `nieczynne_zrodla` ()  BEGIN
SELECT __projekt_zrodlo.ID_zrodlo,__projekt_zrodlo.adres,__projekt_zrodlo.aktywnosc,__projekt_seria.nr_serii,__projekt_seria.data_produkcji FROM __projekt_zrodlo,__projekt_seria   WHERE aktywnosc='NIE' AND __projekt_zrodlo.ID_zrodlo=__projekt_seria.zrodlo ORDER BY __projekt_zrodlo.ID_zrodlo;
END$$

--
-- Funkcje
--
CREATE DEFINER=`root`@`localhost` FUNCTION `cena_jednostkowa` (`id` INT) RETURNS VARCHAR(20) CHARSET utf8mb4 COLLATE utf8mb4_bin BEGIN
DECLARE cn FLOAT;
DECLARE n FLOAT;
DECLARE c FLOAT;
SELECT naklad INTO @n FROM __projekt_seria WHERE nr_serii=id;
SELECT cena_calkowita INTO @c FROM __projekt_seria WHERE nr_serii=id;
RETURN CONCAT(@c/@n);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `__projekt_butelki`
--

CREATE TABLE `__projekt_butelki` (
  `ID_butelki` int(11) NOT NULL,
  `styl` varchar(10) COLLATE utf8mb4_bin DEFAULT NULL,
  `material` enum('szklo','plastik','inne') COLLATE utf8mb4_bin DEFAULT NULL,
  `pojemnsc` enum('0.5','1','1.5','2','5') COLLATE utf8mb4_bin DEFAULT NULL,
  `biodegradowalnosc` enum('TAK','NIE') COLLATE utf8mb4_bin DEFAULT NULL,
  `cena` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `__projekt_butelki`
--

INSERT INTO `__projekt_butelki` (`ID_butelki`, `styl`, `material`, `pojemnsc`, `biodegradowalnosc`, `cena`) VALUES
(1, 'onamo', 'plastik', '1', 'NIE', 0.55),
(2, 'opro', 'szklo', '0.5', 'TAK', 0.42),
(3, 'advaro', 'plastik', '0.5', 'NIE', 0.33),
(4, 'endevo', 'szklo', '2', 'TAK', 0.8),
(5, 'remaro', 'inne', '5', 'TAK', 1),
(6, 'navouci', 'inne', '1.5', 'TAK', 0.2);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `__projekt_klienci`
--

CREATE TABLE `__projekt_klienci` (
  `ID_klient` int(11) NOT NULL,
  `nazwa` varchar(45) COLLATE utf8mb4_bin NOT NULL,
  `typ_zakladu` enum('market','hurtownia','sklep prywatny') COLLATE utf8mb4_bin DEFAULT NULL,
  `adres` varchar(45) COLLATE utf8mb4_bin NOT NULL,
  `woz_dostawczy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `__projekt_klienci`
--

INSERT INTO `__projekt_klienci` (`ID_klient`, `nazwa`, `typ_zakladu`, `adres`, `woz_dostawczy`) VALUES
(1, 'Biedronka', 'market', 'Słoneczna 23c 14-550 Kraków', 1),
(2, 'Zabka', 'sklep prywatny', 'Ziemiona 34/7 12-900 Bydgoszcz', 2),
(3, 'Makro', 'hurtownia', 'Bartyska 5 11-890 Bialystok', 3),
(4, 'Lewiatan', 'sklep prywatny', 'Schodowo 3/4 12-231 Olsza', 4),
(5, 'Lidl', 'market', 'Martyska 4b 20-940 Kwidly', 5),
(6, 'Makro', 'hurtownia', 'Morska 9 10-100 Jakubow', 6);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `__projekt_seria`
--

CREATE TABLE `__projekt_seria` (
  `nr_serii` int(11) NOT NULL,
  `butelka` int(11) NOT NULL,
  `data_produkcji` date DEFAULT NULL,
  `data_waznosci` date DEFAULT NULL,
  `naklad` float DEFAULT NULL,
  `zrodlo` int(11) DEFAULT NULL,
  `klient` int(11) NOT NULL,
  `cena_calkowita` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `__projekt_seria`
--

INSERT INTO `__projekt_seria` (`nr_serii`, `butelka`, `data_produkcji`, `data_waznosci`, `naklad`, `zrodlo`, `klient`, `cena_calkowita`) VALUES
(153001, 1, '2020-12-16', '2021-05-06', 4900, 1, 1, 5000),
(234003, 3, '2019-09-09', '2020-02-13', 8000, 6, 1, 15000),
(412008, 4, '2021-06-09', '2021-08-03', 1670, 4, 5, 3556),
(432002, 2, '2020-01-10', '2020-05-12', 8090, 2, 1, 13020),
(534005, 1, '2019-11-12', '2020-04-23', 6780, 5, 5, 9000),
(541004, 6, '2019-02-01', '2019-12-14', 3400, 2, 4, 6000),
(618011, 6, '2020-07-14', '2020-09-11', 5600, 8, 2, 10460),
(674009, 4, '2019-12-31', '2020-05-23', 25640, 7, 3, 40513),
(897006, 2, '2020-03-23', '2020-06-09', 9800, 3, 3, 14500),
(912010, 3, '2019-11-01', '2019-12-13', 23400, 8, 6, 39233),
(921007, 4, '2018-01-24', '2019-01-24', 12000, 4, 6, 20460);

--
-- Wyzwalacze `__projekt_seria`
--
DELIMITER $$
CREATE TRIGGER `naprawa_ceny` BEFORE INSERT ON `__projekt_seria` FOR EACH ROW BEGIN
IF NEW.cena_calkowita < NEW.naklad OR NEW.naklad < 0 THEN
SET NEW.cena_calkowita = NEW.naklad * 1.5;
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `naprawa_nakladu` BEFORE INSERT ON `__projekt_seria` FOR EACH ROW BEGIN
IF NEW.naklad < 0 THEN
SET NEW.naklad = NEW.naklad * -1;
END IF;
IF NEW.naklad = 0 THEN
SET NEW.naklad = 1;
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `__projekt_wozy_dostawcze`
--

CREATE TABLE `__projekt_wozy_dostawcze` (
  `ID_wozu` int(11) NOT NULL,
  `typ_wozu` enum('bus','ciezarowy','osobowy') COLLATE utf8mb4_bin NOT NULL,
  `rejestracja` varchar(10) COLLATE utf8mb4_bin NOT NULL,
  `VIN` varchar(45) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `__projekt_wozy_dostawcze`
--

INSERT INTO `__projekt_wozy_dostawcze` (`ID_wozu`, `typ_wozu`, `rejestracja`, `VIN`) VALUES
(1, 'bus', 'OL 532JL', 'LA2YZ23J9P4922301'),
(2, 'osobowy', 'NKW 9012', 'LA2YZ23J9P4922323'),
(3, 'ciezarowy', 'BY C9012', 'LA2YZ23J9P4990310'),
(4, 'osobowy', 'NKE 99OP', 'LA2YZ23J9P4912310'),
(5, 'bus', 'NBA 09W4', 'LA2YZ23J9P4915498'),
(6, 'ciezarowy', 'WML O67K', 'LA2YZ23J9P4983477');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `__projekt_zrodlo`
--

CREATE TABLE `__projekt_zrodlo` (
  `ID_zrodlo` int(11) NOT NULL,
  `adres` varchar(45) COLLATE utf8mb4_bin DEFAULT NULL,
  `jakosc_wody` enum('1','2','3','4','5') COLLATE utf8mb4_bin DEFAULT NULL,
  `aktywnosc` enum('TAK','NIE') COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `__projekt_zrodlo`
--

INSERT INTO `__projekt_zrodlo` (`ID_zrodlo`, `adres`, `jakosc_wody`, `aktywnosc`) VALUES
(1, 'Krakowska 10b 23-990 Mroczkow', '1', 'TAK'),
(2, 'Polna 4b 12-300 Jelenia Góra', '1', 'TAK'),
(3, 'Grodowa 4/5 11-230 Zakopane', '4', 'TAK'),
(4, 'Sloneczna 2 17-420 Kolno', '3', 'TAK'),
(5, 'Jasna 8/12 9-990 Zagrzeb', '5', 'TAK'),
(6, 'Orzeszkowej 3 10-329 Gronowo', '2', 'TAK'),
(7, 'Sikorskiego 2b 23-910 Myszow', '2', 'NIE'),
(8, 'Dostojewskiego 9a 11-400 Ketrzyn', '1', 'NIE');

--
-- Wyzwalacze `__projekt_zrodlo`
--
DELIMITER $$
CREATE TRIGGER `naprawa` BEFORE INSERT ON `__projekt_zrodlo` FOR EACH ROW BEGIN
IF NEW.jakosc_wody = 0
THEN
SET NEW.jakosc_wody = 1;
END IF;
END
$$
DELIMITER ;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `__projekt_butelki`
--
ALTER TABLE `__projekt_butelki`
  ADD PRIMARY KEY (`ID_butelki`);

--
-- Indeksy dla tabeli `__projekt_klienci`
--
ALTER TABLE `__projekt_klienci`
  ADD PRIMARY KEY (`ID_klient`),
  ADD KEY `woz_dostawczy` (`woz_dostawczy`);

--
-- Indeksy dla tabeli `__projekt_seria`
--
ALTER TABLE `__projekt_seria`
  ADD PRIMARY KEY (`nr_serii`),
  ADD KEY `butelka` (`butelka`),
  ADD KEY `zrodlo` (`zrodlo`),
  ADD KEY `klient` (`klient`);

--
-- Indeksy dla tabeli `__projekt_wozy_dostawcze`
--
ALTER TABLE `__projekt_wozy_dostawcze`
  ADD PRIMARY KEY (`ID_wozu`);

--
-- Indeksy dla tabeli `__projekt_zrodlo`
--
ALTER TABLE `__projekt_zrodlo`
  ADD PRIMARY KEY (`ID_zrodlo`);

--
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `__projekt_butelki`
--
ALTER TABLE `__projekt_butelki`
  MODIFY `ID_butelki` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT dla tabeli `__projekt_klienci`
--
ALTER TABLE `__projekt_klienci`
  MODIFY `ID_klient` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT dla tabeli `__projekt_seria`
--
ALTER TABLE `__projekt_seria`
  MODIFY `nr_serii` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=921012;

--
-- AUTO_INCREMENT dla tabeli `__projekt_wozy_dostawcze`
--
ALTER TABLE `__projekt_wozy_dostawcze`
  MODIFY `ID_wozu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT dla tabeli `__projekt_zrodlo`
--
ALTER TABLE `__projekt_zrodlo`
  MODIFY `ID_zrodlo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `__projekt_klienci`
--
ALTER TABLE `__projekt_klienci`
  ADD CONSTRAINT `__projekt_klienci_ibfk_1` FOREIGN KEY (`woz_dostawczy`) REFERENCES `__projekt_wozy_dostawcze` (`ID_wozu`);

--
-- Ograniczenia dla tabeli `__projekt_seria`
--
ALTER TABLE `__projekt_seria`
  ADD CONSTRAINT `__projekt_seria_ibfk_1` FOREIGN KEY (`butelka`) REFERENCES `__projekt_butelki` (`ID_butelki`),
  ADD CONSTRAINT `__projekt_seria_ibfk_2` FOREIGN KEY (`zrodlo`) REFERENCES `__projekt_zrodlo` (`ID_zrodlo`),
  ADD CONSTRAINT `__projekt_seria_ibfk_3` FOREIGN KEY (`klient`) REFERENCES `__projekt_klienci` (`ID_klient`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
