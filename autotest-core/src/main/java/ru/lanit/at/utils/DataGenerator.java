package ru.lanit.at.utils;

import com.github.javafaker.Faker;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.concurrent.ThreadLocalRandom;

import static org.apache.commons.lang3.RandomStringUtils.randomAlphabetic;
import static org.apache.commons.lang3.RandomStringUtils.randomNumeric;

public class DataGenerator {

    /**
     * Генерирует набор русских, английских букв и цифр по маске
     * <p>
     * <br/> R - русская буква
     * <br/> D - цифра
     * <br/> W - английская буква
     *
     * @return - рандомная строка
     */
    public static String generateValueByMask(String mask) {
        StringBuilder result = new StringBuilder();
        char[] chars = mask.toCharArray();
        for (char aChar : chars) {
            switch (String.valueOf(aChar)) {
                case "R":
                    result.append(getRussianLetter());
                    break;
                case "D":
                    result.append(randomNumeric(1));
                    break;
                case "E":
                    result.append(randomAlphabetic(1).toLowerCase());
                    break;
                default:
                    result.append(aChar);
                    break;
            }
        }
        result.trimToSize();
        return result.toString();
    }

    public static String generateValueByTypeOfVar(String varType) {
        Faker faker = new Faker(new Locale("ru"));
        String result = "";
        switch (varType) {
            case "first_name":
                result = faker.name().firstName();
                break;
            case "last_name":
                result = faker.name().lastName();
                break;
            case "id":
                result = faker.numerify("########");
                break;
            case "home_town":
                result = faker.address().city();
                break;
            case "status":
                result = "Онлайн";
                break;
            case "bdate":
                result = LocalDate.now().minusYears(18).format(DateTimeFormatter.ofPattern("d.M.yyyy"));
                break;
            case "bdate_visibility":
                result = randomNumeric(0, 2);
                break;
            case "country":
                result = randomNumeric(1);
                break;
            case "phone":
                result = faker.phoneNumber().phoneNumber();
                break;
            case "relation":
                result = randomNumeric(0, 8);
                break;
            case "sex":
                result = randomNumeric(1, 2);
                break;
            case "topic_text":
            case "message1_text":
            case "message2_text":
            case "message3_text":
            case "message4_text":
                result = faker.shakespeare().hamletQuote();
                break;
        }
        return result;
    }

    /**
     * рандомная русская буква
     *
     * @return рандомная русская буква
     */
    private static String getRussianLetter() {
        int leftLimit = 1040;
        int rightLimit = leftLimit + 33;
        String res = "";
        int a = ThreadLocalRandom.current().nextInt(leftLimit, rightLimit + 1);
        char symbol = (char) a;
        res += symbol;
        return res;
    }
}
