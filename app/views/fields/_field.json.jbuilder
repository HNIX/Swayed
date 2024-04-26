json.extract! field, :id, :name

json.sgid field.attachable_sgid
json.content render(partial: "field", locals: { field: field }, formats: [:html])