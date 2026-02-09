import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/domain/models/default_categories.dart';
import 'package:finapp/data/repositories/finance_repository.dart';

class FinanceRepositoryFirebase implements FinanceRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FinanceRepositoryFirebase({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  DocumentReference _userDoc(String userId) =>
      _firestore.collection('users').doc(userId);

  // --- Helpers ---

  Future<List<T>> _getCollection<T>({
    required String userId,
    required String collectionPath,
    required T Function(Map<String, dynamic>) fromMap,
  }) async {
    final snapshot = await _userDoc(userId).collection(collectionPath).get();
    return snapshot.docs.map((doc) => fromMap(doc.data())).toList();
  }

  Future<void> _addDocument<T>({
    required String userId,
    required String collectionPath,
    required T item,
    required String id,
    required Map<String, dynamic> Function() toMap,
  }) async {
    await _userDoc(userId).collection(collectionPath).doc(id).set(toMap());
  }

  Future<void> _updateDocument<T>({
    required String userId,
    required String collectionPath,
    required String id,
    required Map<String, dynamic> Function() toMap,
  }) async {
    await _userDoc(userId).collection(collectionPath).doc(id).update(toMap());
  }

  Future<void> _deleteDocument({
    required String userId,
    required String collectionPath,
    required String id,
  }) async {
    await _userDoc(userId).collection(collectionPath).doc(id).delete();
  }

  // --- Accounts ---

  @override
  Future<List<Account>> getAccounts(String userId) async {
    return _getCollection(
      userId: userId,
      collectionPath: 'accounts',
      fromMap: Account.fromMap,
    );
  }

  @override
  Future<void> addAccount(String userId, Account acc) {
    return _addDocument(
      userId: userId,
      collectionPath: 'accounts',
      item: acc,
      id: acc.id,
      toMap: acc.toMap,
    );
  }

  @override
  Future<void> updateAccount(String userId, Account acc) {
    return _updateDocument(
      userId: userId,
      collectionPath: 'accounts',
      id: acc.id,
      toMap: acc.toMap,
    );
  }

  @override
  Future<void> deleteAccount(String userId, String accountId) {
    return _deleteDocument(
      userId: userId,
      collectionPath: 'accounts',
      id: accountId,
    );
  }

  // --- Transactions ---

  @override
  Future<List<Transaction>> getTransactions(String userId) async {
    final snapshot = await _userDoc(
      userId,
    ).collection('transactions').orderBy('date', descending: true).get();
    return snapshot.docs.map((doc) => Transaction.fromMap(doc.data())).toList();
  }

  @override
  Future<void> addTransaction(String userId, Transaction tx) {
    return _addDocument(
      userId: userId,
      collectionPath: 'transactions',
      item: tx,
      id: tx.id,
      toMap: tx.toMap,
    );
  }

  @override
  Future<void> updateTransaction(String userId, Transaction tx) {
    return _updateDocument(
      userId: userId,
      collectionPath: 'transactions',
      id: tx.id,
      toMap: tx.toMap,
    );
  }

  @override
  Future<void> deleteTransaction(String userId, String transactionId) {
    return _deleteDocument(
      userId: userId,
      collectionPath: 'transactions',
      id: transactionId,
    );
  }

  // --- Categories ---

  @override
  Future<List<Category>> getCategories(String userId) async {
    return _getCollection(
      userId: userId,
      collectionPath: 'categories',
      fromMap: Category.fromMap,
    );
  }

  @override
  Future<void> addCategory(String userId, Category cat) {
    return _addDocument(
      userId: userId,
      collectionPath: 'categories',
      item: cat,
      id: cat.id,
      toMap: cat.toMap,
    );
  }

  @override
  Future<void> updateCategory(String userId, Category cat) {
    return _updateDocument(
      userId: userId,
      collectionPath: 'categories',
      id: cat.id,
      toMap: cat.toMap,
    );
  }

  @override
  Future<void> deleteCategory(String userId, String categoryId) {
    return _deleteDocument(
      userId: userId,
      collectionPath: 'categories',
      id: categoryId,
    );
  }

  // --- Tags ---

  @override
  Future<List<Tag>> getTags(String userId) async {
    return _getCollection(
      userId: userId,
      collectionPath: 'tags',
      fromMap: Tag.fromMap,
    );
  }

  @override
  Future<void> addTag(String userId, Tag tag) {
    return _addDocument(
      userId: userId,
      collectionPath: 'tags',
      item: tag,
      id: tag.id,
      toMap: tag.toMap,
    );
  }

  @override
  Future<void> updateTag(String userId, Tag tag) {
    return _updateDocument(
      userId: userId,
      collectionPath: 'tags',
      id: tag.id,
      toMap: tag.toMap,
    );
  }

  @override
  Future<void> deleteTag(String userId, String tagId) {
    return _deleteDocument(userId: userId, collectionPath: 'tags', id: tagId);
  }

  // --- Budgets ---

  @override
  Future<List<Budget>> getBudgets(String userId) async {
    return _getCollection(
      userId: userId,
      collectionPath: 'budgets',
      fromMap: Budget.fromMap,
    );
  }

  @override
  Future<void> addBudget(String userId, Budget budget) {
    return _addDocument(
      userId: userId,
      collectionPath: 'budgets',
      item: budget,
      id: budget.id,
      toMap: budget.toMap,
    );
  }

  @override
  Future<void> updateBudget(String userId, Budget budget) {
    return _updateDocument(
      userId: userId,
      collectionPath: 'budgets',
      id: budget.id,
      toMap: budget.toMap,
    );
  }

  @override
  Future<void> deleteBudget(String userId, String budgetId) {
    return _deleteDocument(
      userId: userId,
      collectionPath: 'budgets',
      id: budgetId,
    );
  }

  // --- Persons ---

  @override
  Future<List<Person>> getPersons(String userId) async {
    return _getCollection(
      userId: userId,
      collectionPath: 'persons',
      fromMap: Person.fromMap,
    );
  }

  @override
  Future<void> addPerson(String userId, Person person) {
    return _addDocument(
      userId: userId,
      collectionPath: 'persons',
      item: person,
      id: person.id,
      toMap: person.toMap,
    );
  }

  @override
  Future<void> updatePerson(String userId, Person person) {
    return _updateDocument(
      userId: userId,
      collectionPath: 'persons',
      id: person.id,
      toMap: person.toMap,
    );
  }

  @override
  Future<void> deletePerson(String userId, String personId) {
    return _deleteDocument(
      userId: userId,
      collectionPath: 'persons',
      id: personId,
    );
  }

  @override
  Future<void> loadDefaultCategories(String userId) async {
    // Load default categories to Firebase for new users
    final existingCategories = await getCategories(userId);
    if (existingCategories.isEmpty) {
      // Batch write all default categories
      final batch = _firestore.batch();
      for (final category in DefaultCategories.predefinedCategories) {
        final docRef = _userDoc(
          userId,
        ).collection('categories').doc(category.id);
        batch.set(docRef, category.toMap());
      }
      await batch.commit();
    }
  }
}
