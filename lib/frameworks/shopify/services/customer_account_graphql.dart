class CustomerAccountAPI {
  static const String getOrders = '''
  query(\$cursor: String, \$pageSize: Int) {
    customer {
      orders(first: \$pageSize, after: \$cursor, reverse: true) {
        pageInfo {
          hasNextPage
          hasPreviousPage
        }
         edges {
          cursor
          node {
            id
            createdAt
            processedAt
            name
            currencyCode
            paymentInformation {
              totalPaidAmount {
                amount
                currencyCode
              }
              paymentStatus
              totalPaidAmount {
                amount
                currencyCode
              }
              paymentCollectionUrl
            }
            financialStatus
            processedAt
            currencyCode
            totalPrice {
              amount
            }
            statusPageUrl
            totalTax {
              amount
            }
            subtotal {
              amount
            }
            totalShipping {
              amount
            }
            shippingAddress {
              address1
              address2
              city
              company
              country
              firstName
              id
              lastName
              zip
              province
              name
              lastName
            }
            lineItems(first: 100) {
              pageInfo {
                hasNextPage
                hasPreviousPage
              }
              edges {
                node {
                  productId
                  quantity
                  title
                  id
                  title
                  quantity
                  price {
                    amount
                    currencyCode
                  }
                  totalPrice {
                    amount
                    currencyCode
                  }
                  currentTotalPrice {
                    amount
                    currencyCode
                  }
                  image {
                    url
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  ''';

  static const String getCustomerInfo = '''
  query {
    customer {
      ...customerInformation
    }
  }
  $fragmentCustomer
  ''';

  static const String customerUpdate = '''
  mutation customerUpdate(\$input: CustomerUpdateInput!) {
    customerUpdate(input: \$input) {
      userErrors {
        field
        message
      }
      customer {
        ...customerInformation
      }
    }
  }
  $fragmentCustomer
  ''';

  static const String fragmentCustomer = '''
  fragment customerInformation on Customer {
      id
      firstName
      lastName
      displayName
      emailAddress {
        emailAddress
      } 
  }
  ''';
}
