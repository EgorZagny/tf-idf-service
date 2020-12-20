FROM elixir:1.11.2-alpine

WORKDIR /opt/tf_idf

COPY tf_idf_service .

EXPOSE 4001

CMD ./tf_idf_service