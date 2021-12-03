package ru.lanit.at.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.ru.И;
import io.cucumber.java.ru.Пусть;
import io.qameta.allure.Allure;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testng.Assert;
import ru.lanit.at.api.ApiRequest;
import ru.lanit.at.api.models.RequestModel;
import ru.lanit.at.api.testcontext.ContextHolder;
import ru.lanit.at.utils.CompareUtil;
import ru.lanit.at.utils.DataGenerator;
import ru.lanit.at.utils.Sleep;
import ru.lanit.at.utils.VariableUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import static ru.lanit.at.api.testcontext.ContextHolder.replaceVarsIfPresent;
import static ru.lanit.at.utils.JsonUtil.getFieldFromJson;

public class ApiSteps {

    private static final Logger LOG = LoggerFactory.getLogger(ApiSteps.class);
    private ApiRequest apiRequest;
    private Map<String, String> randomProfile = new HashMap<>();
    private Map<String, String> actualProfile = new HashMap<>();
    private Map<String, String> profileDiff = new HashMap<>();

    @И("создать запрос")
    public void createRequest(RequestModel requestModel) {
        apiRequest = new ApiRequest(requestModel);
    }

    @И("добавить header")
    public void addHeaders(DataTable dataTable) {
        Map<String, String> headers = new HashMap<>();
        dataTable.asLists().forEach(it -> headers.put(it.get(0), it.get(1)));
        apiRequest.setHeaders(headers);
    }

    @И("добавить query параметры")
    public void addQuery(DataTable dataTable) {
        Map<String, String> query = new HashMap<>();
        dataTable.asLists().forEach(it -> query.put(replaceVarsIfPresent(it.get(0)), replaceVarsIfPresent(it.get(1))));
        apiRequest.setQuery(query);
    }

    @И("добавить query параметры для добавления информации")
    public void addQueryFromMap(DataTable dataTable) {
        Map<String, String> query = new HashMap<>();
        dataTable.asLists().forEach(it -> query.put(replaceVarsIfPresent(it.get(0)), replaceVarsIfPresent(it.get(1))));
        query.putAll(profileDiff);
        apiRequest.setQuery(query);
    }

    @И("отправить запрос")
    public void send() {
        apiRequest.sendRequest();
    }

    @И("статус код {int}")
    public void expectStatusCode(int code) {
        int actualStatusCode = apiRequest.getResponse().statusCode();
        Assert.assertEquals(actualStatusCode, code);
    }

    @И("извлечь данные")
    public void extractVariables(Map<String, String> vars) {
        String responseBody = apiRequest.getResponse().body().asPrettyString();
        vars.forEach((k, jsonPath) -> {
            String extractedValue = VariableUtil.extractBrackets(getFieldFromJson(responseBody, jsonPath));
            ContextHolder.put(k, extractedValue);
            actualProfile.put(k, extractedValue);
            Allure.addAttachment(k, "application/json", extractedValue, ".txt");
            LOG.info("Извлечены данные: {}={}", k, extractedValue);
        });
    }

    @И("сгенерировать переменные")
    public void generateVariables(Map<String, String> table) {
        table.forEach((k, v) -> {
            String value = DataGenerator.generateValueByMask(replaceVarsIfPresent(v));
            ContextHolder.put(k, value);
            Allure.addAttachment(k, "application/json", k + ": " + value, ".txt");
            LOG.info("Сгенерирована переменная: {}={}", k, value);
        });
    }

    @И("создать контекстные переменные")
    public void createContextVariables(Map<String, String> table) {
        table.forEach((k, v) -> {
            ContextHolder.put(k, v);
            LOG.info("Сохранена переменная: {}={}", k, v);
        });
    }

    @И("сравнить значения")
    public void compareVars(DataTable table) {
        table.asLists().forEach(it -> {
            String expect = replaceVarsIfPresent(it.get(0));
            String actual = replaceVarsIfPresent(it.get(2));
            boolean compareResult = CompareUtil.compare(expect, actual, it.get(1));
            Assert.assertTrue(compareResult, String.format("Ожидаемое: '%s'\nФактическое: '%s'\nОператор сравнения: '%s'\n", expect, actual, it.get(1)));
            Allure.addAttachment(expect, "application/json", expect + it.get(1) + actual, ".txt");
            LOG.info("Сравнение значений: {} {} {}", expect, it.get(1), actual);
        });
    }

    @И("подождать {int} сек")
    public void waitSeconds(int timeout) {
        Sleep.pauseSec(timeout);
    }

    @Пусть("сгенерировать случайную информацию о профиле")
    public void generateRandomProfileInfo(DataTable table) {
        table.asList().forEach((el) -> {
            String value = DataGenerator.generateValueByTypeOfVar(el);
            randomProfile.put(el, value);
            Allure.addAttachment(el, "application/json", el + ": " + value, ".txt");
            LOG.info("Сгенерирована случайная переменная: {}={}", el, value);
        });
    }

    @Пусть("сгенерировать случайную переменную")
    public void generateRandomVarInfo(DataTable table) {
        table.asList().forEach((el) -> {
            String value = DataGenerator.generateValueByTypeOfVar(el);
            ContextHolder.put(el, value);
            Allure.addAttachment(el, "application/json", el + ": " + value, ".txt");
            LOG.info("Сгенерирована случайная переменная: {}={}", el, value);
        });
    }

    @И("определить недостающую информацию")
    public void countDiff() {
        actualProfile.forEach((k, v) -> {
            if (actualProfile.get(k).isEmpty()) {
                profileDiff.put(k, randomProfile.get(k));
                System.out.println(profileDiff.get(k));
            }
        });
    }

    @И("отправить multipart-form-data запрос")
    public void sendMultipartForm() {
        apiRequest.sendMultipartFormRequest();
    }


    @И("добавить multipart-form-data query параметры")
    public void addMultipartFormQuery(DataTable dataTable) {
        Map<String, String> query = new HashMap<>();
        dataTable.asLists().forEach(it -> query.put(replaceVarsIfPresent(it.get(0)), replaceVarsIfPresent(it.get(1))));
        apiRequest.setMultipartFormQuery(query);
    }
}
