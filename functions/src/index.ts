import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';


// Firebase Admin SDK 초기화
admin.initializeApp();
const db = admin.firestore();

/**
 * 사용자 계정과 Firestore 관련 데이터를 모두 삭제하는 Callable Cloud Function입니다.
 * 앱에서 재인증 후 호출하는 것을 권장합니다.
 */
export const deleteUserDataAndAccount = functions.https.onCall(
  async (request) => {
    // ✅ context 대신 request 사용
    if (!request.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        '인증되지 않은 사용자입니다. 로그인 후 다시 시도해 주세요.'
      );
    }

    const uid: string = request.auth.uid;

    try {
      // 2. Firestore에서 사용자 관련 모든 데이터 삭제

      // 2-1. 'users' 컬렉션의 문서 삭제 (사용자 프로필 문서)
      await db.collection('users').doc(uid).delete();



      // 3. Authentication에서 사용자 계정 삭제
      await admin.auth().deleteUser(uid);

      console.log(`사용자 UID: ${uid}의 데이터와 계정이 모두 삭제되었습니다.`);
      return {
        success: true,
        message: '계정 및 데이터가 성공적으로 삭제되었습니다.'
      };
    } catch (error) {
      console.error(`[UID: ${uid}] 계정 삭제 중 오류 발생:`, error);

      throw new functions.https.HttpsError(
        'internal',
        '서버에서 계정 삭제 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.',
        error
      );
    }
  }
);