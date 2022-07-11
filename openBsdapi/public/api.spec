{
    "openapi": "3.0.3",
    "info": {
        "version": "1.0",
        "title": "OpenBSD REST API",
        "description": "An API to manage OpenBSD machine",
        "contact": {
            "name": "Ricardo Baylon Jr.",
            "url": "https://github.com/rickybaylon"
        }
    },
    "servers": [
        {
            "url": "/api/v1",
            "description": "Version one api"
        }
    ],
    "paths": {
        "/interfaces": {
            "get": {
                "summary": "Get list of interface.",
                "tags": ["Iface"],
                "operationId": "getInterfaces",
                "x-mojo-name": "get_interfaces",
                "x-mojo-to": {
                    "controller": "Interfaces",
                    "action": "get_interfaces"
                },
                "responses": {
                    "200": {
                        "description": "List of interfaces",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "type": "object",
                                    "properties": {
                                        "interfaces": {
                                            "type": "array",
                                            "items": {
                                                "type": "object"
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            },
            "post": {
                "summary": "Add interface",
                "tags": ["IfaceAdd"],
                "operationId": "addInterface",
                "x-mojo-name": "add_interface",
                "x-mojo-to": {
                    "controller": "Interfaces",
                    "action": "add_interface"
                },
                "requestBody": {
                  "description": "Add interface",
                  "required": true,
                  "content": {
                    "application/json": {
                      "schema": {
                        "type": "object",
                        "properties": {
                           "name": {
                            "type": "string"
                           },
                           "auto": {
                               "type": "boolean",
                               "default": true
                           },
                           "addr_family": {
                               "type": "string"
                           },
                           "addr": {
                               "type": "string"
                           },
                           "netmask": {
                               "type": "string"
                           }
                         },
                        "required": [
                           "name",
                           "auto"
                        ]
                      }
                    }
                  }
                },
                "responses": {
                  "200": {
                    "description": "Created"
                   }
                }
            }
       },
       "/interfaces/{id}": {
           "parameters": {
             "in": "path",
             "name": "id",
             "required": true,
             "schema": {
               "type": "integer"
               }
             },
           "get": {
              "summary": "Get interface",
              "tags": ["Iface_info"],
              "operationId": "getInterface",
              "x-mojo-name": "get_interface",
              "x-mojo-to": {
                 "controller": "Interfaces",
                 "action": "get_interface"
              },
              "responses": {
                "200": {
                  "description": "List of interfaces",
                    "content": {
                      "application/json": {
                        "schema": {
                          "type": "object",
                          "properties": {
                            "interfaces": {
                              "type": "array",
                                "items": {
                                  "type": "object"
                                }
                              }
                           }
                         }
                      }
                   }
                }
              }
           }
       }
    }
}
