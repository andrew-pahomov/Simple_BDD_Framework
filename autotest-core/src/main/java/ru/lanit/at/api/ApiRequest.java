package ru.lanit.at.api;

import io.qameta.allure.Allure;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.http.ContentType;
import io.restassured.http.Method;
import io.restassured.path.xml.XmlPath;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.aeonbits.owner.ConfigFactory;
import org.apache.commons.io.IOUtils;
import ru.lanit.at.api.listeners.RestAssuredCustomLogger;
import ru.lanit.at.api.models.RequestModel;
import ru.lanit.at.api.properties.RestConfigurations;
import ru.lanit.at.utils.FileUtil;
import ru.lanit.at.utils.JsonUtil;
import ru.lanit.at.utils.RegexUtil;

import java.io.File;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import static io.restassured.RestAssured.given;
import static ru.lanit.at.api.testcontext.ContextHolder.replaceVarsIfPresent;

public class ApiRequest {

    private final static RestConfigurations CONFIGURATIONS = ConfigFactory.create(RestConfigurations.class,
            System.getProperties(),
            System.getenv());

    private String baseUrl;
    private String path;
    private Method method;
    private String body;
    private String fullUrl;

    private Response response;

    private RequestSpecBuilder builder;

    public ApiRequest(RequestModel requestModel) {
        this.builder = new RequestSpecBuilder();

        this.baseUrl = CONFIGURATIONS.getBaseUrl();
        this.path = replaceVarsIfPresent(requestModel.getPath());
        this.method = Method.valueOf(requestModel.getMethod());
        this.body = requestModel.getBody();
        this.fullUrl = replaceVarsIfPresent(requestModel.getUrl());

        URI uri;

        if (!fullUrl.isEmpty()) {
            uri = URI.create(fullUrl);
        } else {
            uri = URI.create(baseUrl);
            builder.setBasePath(path);
        }

        this.builder.setBaseUri(uri);
        setBodyFromFile();
        addLoggingListener();
    }

    public Response getResponse() {
        return response;
    }

    public String getResponseBody() {
        String responseBody = response.body().asPrettyString();
        if (responseBody.substring(0, 6).equals("<html>")) {
            XmlPath htmlDoc = new XmlPath(XmlPath.CompatibilityMode.HTML, responseBody);
            responseBody = htmlDoc.getString("html.body");
        }
        return responseBody;
    }

    /**
     * Сеттит заголовки
     */
    public void setHeaders(Map<String, String> headers) {
        headers.forEach((k, v) -> {
            builder.addHeader(k, v);
        });
    }

    /**
     * Сеттит query-параметры
     */
    public void setQuery(Map<String, String> query) {
        query.forEach((k, v) -> {
            builder.addQueryParam(k, v);
        });
    }

    /**
     * Сеттит MultipartForm query-параметры
     */
    public void setMultipartFormQuery(Map<String, String> query) {
        query.forEach((k, v) -> {
            builder.addMultiPart(k, v);
        });
        builder.setAccept(ContentType.JSON);
        builder.setContentType(ContentType.MULTIPART);
    }

    /**
     * Сеттит MultipartForm query-параметры
     */
    public void setMultipartFormQueryForFileUpload(Map<String, File> query) {
        query.forEach((k, v) -> {
            builder.addMultiPart(k, v);
        });
        builder.setAccept(ContentType.JSON);
        builder.setContentType(ContentType.MULTIPART);
    }

    /**
     * Отправляет сформированный запрос
     */
    public void sendRequest() {
        RequestSpecification requestSpecification = builder.build();

        Response response = given()
                .spec(requestSpecification)
                .request(method);

        attachRequestResponseToAllure(response, body);
        this.response = response;
    }

    /**
     * Отправляет Multipart Data Form сформированный запрос
     */
    public void sendMultipartFormRequest() {
        RequestSpecification requestSpecification = builder.build();

        Response response = given()
                .spec(requestSpecification)
                .post(fullUrl);

        attachRequestResponseToAllure(response, body);
        this.response = response;
    }

    /**
     * Сессит тело запроса из файла
     */
    private void setBodyFromFile() {
        if (body != null && RegexUtil.getMatch(body, ".*\\.json")) {
            body = replaceVarsIfPresent(FileUtil.readBodyFromJsonDir(body));
            builder.setBody(body);
        }
    }

    /**
     * Аттачит тело запроса и тело ответа в шаг отправки запроса
     */
    private void attachRequestResponseToAllure(Response response, String requestBody) {
        if (requestBody != null) {
            Allure.addAttachment(
                    "Request",
                    "application/json",
                    IOUtils.toInputStream(requestBody, StandardCharsets.UTF_8),
                    ".txt");
        }
        String responseBody = JsonUtil.jsonToUtf(response.body().asPrettyString());
        Allure.addAttachment("Response", "application/json", responseBody, ".txt");
    }

    /**
     * Добавляет логгер, печатающий в консоль данные запросов и ответов
     */
    private void addLoggingListener() {
        builder.addFilter(new RestAssuredCustomLogger());
    }
}

